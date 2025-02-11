//
//  TaskItemView.swift
//  todo-online
//
//  Created by Majid Jamali on 1/16/25.
//

import SwiftUI
import SwiftData

struct TaskItemView: View, Identifiable {
    
    let id: UUID = UUID()
    
    let task: TaskModel
    
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var taskManager: TaskManager
    
    @State private var presentError: Bool = false
    @State private var localError: ErrorResult? = nil
    
    @Query var users: [UserModel]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            Spacer(minLength: 4.0)
            HStack {
                Text(task.title)
                    .font(.headline)
                    .strikethrough(task.isTimeOver())
                Spacer()
                Button {
                    // done or undone task
                    if task.isNotOver() {
                        saveChanges()
                    }
                } label: {
                    if task.isTimeOver() {
                        HStack(spacing: 4.0) {
                            Image(systemName: "clock.badge.exclamationmark")
                            Text("task due over")
                        }
                        .padding(.horizontal, 8.0)
                        .padding(.vertical, 4.0)
                        .background(
                            Capsule()
                                .strokeBorder(lineWidth: 3.0, antialiased: true)
                                .foregroundStyle(Color.selectedTaskDueOver.gradient)
                        )
                        .font(.caption)
                    } else {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(task.isDone ? Color.selectedTaskItem : Color.clear)
                            .padding(5.0)
                            .background(
                                Circle()
                                    .strokeBorder(lineWidth: 3.0, antialiased: true)
                                    .foregroundStyle(task.isDone ? AnyGradient(Gradient(colors: [Color.selectedTaskDone, Color.clear, Color.clear])) : Color.selectedDateBG.gradient)
                            )
                            .buttonStyle(.plain)
                            .font(.system(size: 16))
                            .animation(.easeInOut(duration: 1.0), value: task.lastUpdated)
                    }
                }
            }
            Spacer(minLength: 2.0)
            Text(task.subtitle)
                .font(.subheadline)
                .opacity(0.75)
                .strikethrough(task.isTimeOver())
            Spacer(minLength: 18.0)
            HStack {
                HStack(spacing: 4.0) {
                    Image(systemName: "square.3.layers.3d.top.filled")
                    Text(task.categoryValue.getTitle().capitalized)
                }
                .padding(.horizontal, 8.0)
                .padding(.vertical, 4.0)
                .background(
                    Capsule()
                        .strokeBorder(lineWidth: 3.0, antialiased: true)
                        .foregroundStyle(Color.selectedDateBG.gradient)
                )
                .font(.caption)
                Spacer()
                HStack(spacing: 4.0) {
                    TaskPriorityWaveView(priority: .constant(task.priorityValue))
                }
                .padding(.horizontal, 8.0)
                .padding(.vertical, 4.0)
                .background(
                    Capsule()
                        .strokeBorder(lineWidth: 3.0, antialiased: true)
                        .foregroundStyle(Color.selectedDateBG.gradient)
                )
                .font(.caption)
            }
            Spacer(minLength: 8.0)
            HStack {
                HStack(spacing: 4.0) {
                    Image(systemName: "calendar")
                    Text(task.dueDate.getMonth() + " " + task.dueDate.getDay())
                }
                .padding(.horizontal, 8.0)
                .padding(.vertical, 4.0)
                .background(
                    Capsule()
                        .strokeBorder(lineWidth: 3.0, antialiased: true)
                        .foregroundStyle(Color.selectedDateBG.gradient)
                )
                .font(.caption)
                Spacer()
                HStack(spacing: 4.0) {
                    Image(systemName: "clock.badge.fill")
                    Text(task.dueDate.formatted(date: .omitted, time: .shortened))
                }
                .padding(.horizontal, 8.0)
                .padding(.vertical, 4.0)
                .background(
                    Capsule()
                        .strokeBorder(lineWidth: 3.0, antialiased: true)
                        .foregroundStyle(Color.selectedDateBG.gradient)
                )
                .font(.caption2)
            }
            Spacer(minLength: 4.0)
        }
        .foregroundStyle(Color.selectedTaskItem)
        .padding(16.0)
        .background(
            RoundedRectangle(cornerRadius: 18.0)
                .foregroundStyle(Color.selectedTaskItemBG)
        )
        .padding(.horizontal, 18.0)
        .modifier(ErrorAlertViewModifier(isShowing: $presentError, error: $localError))
    }
    
    func saveChanges() {
        localError = nil
        do {
            try modelContext.transaction {
                withAnimation(.default) {
                    task.isDone.toggle()
                }
                try modelContext.save()
            }
        } catch {
            let error = ErrorResult(message: error.localizedDescription, error: "saving state error", statusCode: -2)
            localError = error
            presentError.toggle()
            return
        }
        saveChangesOnline { result, error in
            if let error {
                localError = error
                presentError.toggle()
                return
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

#Preview {
    ContentView()
}
