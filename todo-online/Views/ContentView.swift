//
//  ContentView.swift
//  todo-online
//
//  Created by Majid Jamali on 1/15/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @EnvironmentObject var taskManager: TaskManager
    @State private var searchPredicate: Predicate<TaskModel> = .false
    @Environment(\.modelContext) var modelContext
    
    @Query var users: [UserModel]
    @Query var tasks: [TaskModel]
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                VStack(spacing: 20.0) {
                    
                    DateScrollsView()
                        .onAppear {
                            taskManager.shouldShowToday.toggle()
                        }
                    
                    TaskItemsScrollView(predicate: searchPredicate)
                    
                    Spacer()
                }
                
                addButtonView()
                
            }
            .ignoresSafeArea(.all, edges: .bottom)
            .onAppear {
                if users.isEmpty {
                    taskManager.showUserLogin.toggle()
                } else {
                    taskManager.getAll(users.first?.accessToken) { results, error in
                        // update items from cloud
                        if let results {
                            for res in results {
                                if let index = tasks.firstIndex(where: { $0.itemId == res.id }) {
                                    let item = tasks[index]
                                    item.title = res.title
                                    item.subtitle = res.description
                                    item.isDone = res.isCompleted
                                } else {
                                    let newTask = TaskModel(id: UUID().uuidString, itemId: res.id, title: res.title, subtitle: res.description, details: "", category: TaskModel.Category.routine.rawValue, priority: TaskModel.Priority.low.rawValue, dueDate: .now, dueDateString: Date.now.toDateStringFormat(), isDone: res.isCompleted, userData: users.first?.userName, createdDate: .now, lastUpdated: .now)
                                    do {
                                        try modelContext.transaction {
                                            modelContext.insert(newTask)
                                            try modelContext.save()
                                            
                                        }
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                    
                                    
                                }
                            }
                        }
                        
                        // update items to cloud...
//                        for task in tasks {
//                            if let index = results?.contains(where: { $0.id == task.itemId }) {
//                                // if anything is different, update it!
//                            } else {
//                                // something is missing to upload, add it!
//                            }
//                        }
                    }
                }
            }
            .sheet(isPresented: $taskManager.showAddView) {
                AddNewTaskView()
                    .presentationDetents([.medium, .large], selection: $taskManager.presentationDetent)
            }
            .sheet(isPresented: $taskManager.showUserLogin) {
                SignInView()
                    .presentationDetents([.fraction(0.5)])
            }
            .sheet(isPresented: $taskManager.showUserProfile, content: {
                UserProfileView()
                    .presentationDetents([.medium, .large])
            })
            .onChange(of: taskManager.selectedDate, { _, newValue in
                let dateString = taskManager.selectedDate.toDateStringFormat()
                searchPredicate = #Predicate<TaskModel> {
                    $0.dueDateString == dateString
                }
            })
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Text("To do list").fontDesign(.monospaced).font(.title2.smallCaps())
                }
                ToolbarItem(placement: .primaryAction) {
                    HStack {
                        Button {
                            taskManager.shouldShowToday.toggle()
                        } label: {
                            Image(systemName: "calendar.day.timeline.left")
                        }
                        
                        Button {
                            taskManager.showJustTaskDays.toggle()
                            taskManager.shouldShowToday.toggle()
                        } label: {
                                Image(systemName: taskManager.showJustTaskDays ? "calendar.badge.clock" : "calendar")
                                .foregroundStyle(tasks.isEmpty ? Color.nonSelectedDate.gradient : Color.selectedDateBG.gradient)
                        }
                        .disabled(tasks.isEmpty)
                        
                        Button {
                            // goto user view
                            if users.isEmpty {
                                taskManager.showUserLogin.toggle()
                            } else {
                                // go to userProfileView
                                taskManager.showUserProfile.toggle()
                            }
                        } label: {
                            Image(systemName: users.isEmpty ? "person.badge.shield.exclamationmark" : "person.badge.shield.checkmark.fill")
                        }
                    }
                    .foregroundStyle(Color.selectedDateBG.gradient)
                    .font(.headline.bold())
                }
            }
        }
    }
    
    
    func addButtonView() -> some View {
        return Button {
            // add
            taskManager.showAddView.toggle()
        } label: {
            ZStack {
                Circle()
                    .foregroundStyle(Color.nonSelectedTaskItem.gradient)
                    .frame(width: 50.0, height: 50.0)
                    .padding(36.0)
                    .shadow(color: Color.nonSelectedTaskItem.opacity(0.25), radius: 8.0, x: 4.0, y: 4.0)
                
                Image(systemName: "plus")
                    .foregroundStyle(Color.selectedTaskItem)
                    .font(.title2.bold())
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContentView()
}
