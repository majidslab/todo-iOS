//
//  AddNewTaskView.swift
//  todo-online
//
//  Created by Majid Jamali on 1/21/25.
//

import SwiftUI
import SwiftData


struct AddNewTaskView: View {
    
    @State private var title: String = "Title"
    @State private var subtitle: String = "Subtitle"
    @State private var details: String = "no details"
    @State private var category: TaskModel.Category = .routine
    @State private var priority: TaskModel.Priority = .low
    @State private var dueDate: Date = .now
    // must generate: dueDateString, isDone, userData, createdDate, updatedDate
    
    @Query var users: [UserModel]
    @Query var tasks: [TaskModel]
    
    @EnvironmentObject var taskManager: TaskManager
    @Environment(\.modelContext) private var modelContext
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0.0) {
            HStack {
                
                Spacer()
                
                Button {
                    // save item
                    
                    let dueDateString = dueDate.toDateStringFormat()
                    let isDone = false
                    let userData: String? = users.first?.userName
                    let createdDate = Date.now
                    let lastUpdated = createdDate
                    
                    let newItem = TaskModel(id: UUID().uuidString, itemId: -1, title: title, subtitle: subtitle, details: details, category: category.rawValue, priority: priority.rawValue, dueDate: dueDate, dueDateString: dueDateString, isDone: isDone, userData: userData, createdDate: createdDate, lastUpdated: lastUpdated)
                    
                    saveItem(item: newItem)
                } label: {
                    Text("Save")
                        .foregroundStyle(Color.selectedTaskItem)
                        .padding(.horizontal, 18.0)
                        .padding(.vertical, 8.0)
                        .background(
                            ZStack {
                                Capsule()
                                    .foregroundStyle(Color.selectedDateBG.gradient)
                                    .rotationEffect(.degrees(360))
                                    .padding(8.0)
                                Capsule()
                                    .strokeBorder(lineWidth: 3.0, antialiased: true)
                                    .foregroundStyle(AnyGradient(Gradient(colors: [Color.selectedDateBG, Color.clear, Color.clear])))
                            }
                        )
                        .font(.headline)
                        .buttonStyle(.plain)
                }
                .padding(.top, 24.0)
                .padding(.horizontal, 12.0)
            }
            List {
                AddTaskListItemView(title: "Preview") {
                    AddTaskPreview(title: $title, subtitle: $subtitle, details: $details, category: $category, priority: $priority, dueDate: $dueDate)
                        .padding(.top, 12.0)
                }
                AddTaskListItemView(title: "Title") {
                    TextField("Title", text: $title, prompt: Text("Insert task title"), axis: .vertical)
                        .autocorrectionDisabled()
                }
                AddTaskListItemView(title: "Subtitle") {
                    TextField("Subtitle", text: $subtitle, prompt: Text("Insert task subtitle"), axis: .vertical)
                        .autocorrectionDisabled()
                }
                AddTaskListItemView(title: "Priority") {
                    Picker(selection: $priority) {
                        ForEach(TaskModel.Priority.allCases, id: \.self) { pri in
                            Text(pri.getTitle())
                        }
                    } label: {
                        Text("Priority")
                    }
                    .pickerStyle(.segmented)
                    .padding(8.0)
                }
                AddTaskListItemView(title: "Details") {
                    TextField("Details", text: $details, prompt: Text("Insert task details"), axis: .vertical)
                        .autocorrectionDisabled()
                }
                AddTaskListItemView(title: "Category") {
                    Picker(selection: $category) {
                        ForEach(TaskModel.Category.allCases, id: \.self) { cat in
                            Text(cat.getTitle())
                        }
                    } label: {
                        Text("Category")
                    }
                    .pickerStyle(.segmented)
                    .padding(8.0)
                }
                AddTaskListItemView(title: "Due Date") {
                    DatePicker("", selection: $dueDate, in: .now..., displayedComponents: [.date, .hourAndMinute])
                        .pickerStyle(.segmented)
                }
            }
            .listRowInsets(EdgeInsets(top: 8.0, leading: 8.0, bottom: 18.0, trailing: 8.0))
            .listStyle(.plain)
            .padding(.top, 8.0)
        }
    }
    
    func saveItem(item: TaskModel) {
        do {
            try modelContext.transaction {
                if let index = users.first?.tasks?.firstIndex(where: { $0.id == item.id }) {
                    users.first?.tasks![index] = item
                    print("updated with itemId: ", item.itemId)
                } else {
                    users.first?.tasks?.append(item)
                    print("inserted with itemId: ", item.itemId)
                }
                try modelContext.save()
                if item.itemId == -1 {
                    saveOnline(item: item)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveOnline(item: TaskModel) {
        let requestBody = TaskBody(title: title, description: subtitle, isCompleted: item.isDone)
        let userAuth = users.first?.accessToken
        
        let networkManager = NetworkManager()
        networkManager.request(TaskResult.self, url: .todoPOST, method: .post, requestBody: requestBody, isPublicBearer: false, userAuthenticationBearer: userAuth) { result, error in
            
            if let result {
                item.itemId = result.id
                saveItem(item: item)
                DispatchQueue.main.async {
                    dismiss()
                }
            }
        }
    }
}
