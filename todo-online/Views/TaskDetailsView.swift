//
//  TaskDetailsView.swift
//  todo-online
//
//  Created by Majid Jamali on 1/28/25.
//

import SwiftUI
import SwiftData

struct TaskDetailsView: View {
    let task: TaskModel
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = "Title"
    @State private var subtitle: String = "Subtitle"
    @State private var details: String = "no details"
    @State private var category: TaskModel.Category = .routine
    @State private var priority: TaskModel.Priority = .low
    @State private var dueDate: Date = .now
    // must generate: dueDateString, isDone, userData, createdDate, updatedDate
    
    @Query var users: [UserModel]
    
    @EnvironmentObject var taskManager: TaskManager
    @Environment(\.modelContext) private var modelContext
    
    @State private var isEditingDisabled = true
    
    @State private var presentError: Bool = false
    @State private var localError: ErrorResult? = nil
    
    private var isChanged: Bool {
        task.title != title || task.subtitle != subtitle || task.details != details || task.category != category.rawValue || task.priority != priority.rawValue || task.dueDate != dueDate
    }
    
    var body: some View {
        VStack(spacing: 18.0) {
            List {
                AddTaskListItemView(title: "Preview") {
                    AddTaskPreview(title: $title, subtitle: $subtitle, details: $details, category: $category, priority: $priority, dueDate: $dueDate)
                        .padding(.top, 12.0)
                }
                .disabled(isEditingDisabled)
                AddTaskListItemView(title: "Title") {
                    TextField("Title", text: $title, prompt: Text("Insert task title"), axis: .vertical)
                        .autocorrectionDisabled()
                }
                .disabled(isEditingDisabled)
                AddTaskListItemView(title: "Subtitle") {
                    TextField("Subtitle", text: $subtitle, prompt: Text("Insert task subtitle"), axis: .vertical)
                        .autocorrectionDisabled()
                }
                .disabled(isEditingDisabled)
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
                .disabled(isEditingDisabled)
                AddTaskListItemView(title: "Details") {
                    TextField("Details", text: $details, prompt: Text("Insert task details"), axis: .vertical)
                        .autocorrectionDisabled()
                }
                .disabled(isEditingDisabled)
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
                .disabled(isEditingDisabled)
            }
            
            .listRowInsets(EdgeInsets(top: 8.0, leading: 8.0, bottom: 18.0, trailing: 8.0))
            .listStyle(.plain)
            .padding(.top, 8.0)
            .onAppear {
                self.title = task.title
                self.subtitle = task.subtitle
                self.details = task.details
                self.category = task.categoryValue
                self.priority = task.priorityValue
                self.dueDate = task.dueDate
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(task.title).fontDesign(.monospaced).font(.title3.smallCaps())
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isEditingDisabled.toggle()
                    if isChanged {
                        saveChanges()
                    }
                } label: {
                    Image(systemName: "pencil.line")
                        .foregroundStyle(Color.selectedDateBG.gradient)
                        .font(.headline.bold())
                }
                .buttonStyle(.plain)
            }
            
            ToolbarItem(placement: .navigation) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 2.0) {
                        Image(systemName: "chevron.left")
                            .font(.subheadline)
                        Text("Tasks")
                    }
                    .foregroundStyle(Color.selectedDateBG.gradient)
                    .font(.headline.bold())
                }
                .buttonStyle(.plain)
            }
        }
        .modifier(ErrorAlertViewModifier(isShowing: $presentError, error: $localError))
    }
    
    func saveChanges() {
        localError = nil
        
        let newTask = TaskModel(id: task.id, itemId: task.itemId, title: title, subtitle: subtitle, details: details, category: category.rawValue, priority: priority.rawValue, dueDate: task.dueDate, dueDateString: task.dueDateString, isDone: task.isDone, userData: task.userData, createdDate: task.createdDate, lastUpdated: Date.now)
        
        task.title = newTask.title
        task.subtitle = newTask.subtitle
        task.details = newTask.details
        task.category = newTask.category
        task.priority = newTask.priority
        task.lastUpdated = newTask.lastUpdated
        
        saveChangesOnline { result, error in
            if let error {
                localError = error
                presentError.toggle()
                return
            } else {
                dismiss()
            }
        }
    }

    
    func saveChangesOnline(completion: @escaping((TaskResult?, ErrorResult?) -> Void)) {
        let body = TaskBody(title: task.title, description: task.subtitle, isCompleted: task.isDone)
        let bearer = users.first?.accessToken
        let manager = NetworkManager()
        manager.request(TaskResult.self, url: URL.todoPatchbyAdditiveURL(byAdding: "\(task.itemId)", to: URL.todoPOST), method: .patch, requestBody: body, isPublicBearer: false, userAuthenticationBearer: bearer) { result, error in
            return completion(result, error)
        }
    }
}
