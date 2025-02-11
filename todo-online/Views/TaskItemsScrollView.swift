//
//  TaskItemsScrollView.swift
//  todo-online
//
//  Created by Majid Jamali on 1/21/25.
//

import SwiftUI
import SwiftData

struct TaskItemsScrollView: View {
    
    @Query private var tasks: [TaskModel]
    
    init(predicate: Predicate<TaskModel>) {
        _tasks = Query(filter: predicate)
    }
    
    @Environment(\.modelContext) private var modelContext
    @State private var showRemoveAlert = false
    @State private var selectedItemsToRemove = [TaskModel]()
    
    @State private var destination: TaskModel?
    @State private var present = false
    
    @Query private var users: [UserModel]
    
    var body: some View {
        List {
            ForEach(tasks) { task in
                ZStack {
                    TaskItemView(task: task)
                    NavigationLink {
                        TaskDetailsView(task: task)
                    } label: {
                        EmptyView()
                    }
                    .opacity(0.0)
                }
                .buttonStyle(.plain)
                .listRowSeparatorTint(.clear)
                .listRowInsets(EdgeInsets())
                .safeAreaInset(edge: .top, content: {
                    Spacer(minLength: 8.0)
                })
                .listRowBackground(EmptyView())
            }
            .onDelete(perform: deleteItem)
            .listItemTint(.clear)
            
            Spacer(minLength: 48.0)
                .buttonStyle(.plain)
                .listRowSeparatorTint(.clear)
                .listRowInsets(EdgeInsets())
                .listRowBackground(EmptyView())
                .listItemTint(.clear)
        }
        .listRowInsets(EdgeInsets(top: 8.0, leading: 0.0, bottom: 18.0, trailing: 0.0))
        .listStyle(.plain)
        .padding(.top, 8.0)
        .alert("Proceed deleting Task?", isPresented: $showRemoveAlert) {
            Button("Delete", systemImage: "xmark.bin", role: .destructive) {
                do {
                    try modelContext.transaction {
                        for item in selectedItemsToRemove {
                            deleteItemOnline(item) { result, error in
                                modelContext.delete(item)
                            }
                        }
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func deleteItem(at offsets: IndexSet) {
        selectedItemsToRemove = []
        offsets.forEach { index in
            selectedItemsToRemove.append(tasks[index])
        }
        showRemoveAlert = true
    }
    
    func deleteItemOnline(_ item: TaskModel, resulting: @escaping ((DeleteResult?, ErrorResult?)-> Void) ) {
        let bearer = users.first?.accessToken
        let networkManager = NetworkManager()
        networkManager.request(DeleteResult.self, url: .todoDeletebyAdditiveURL(byAdding: item.itemId, to: .todoGET), method: .delete, requestBody: nil, isPublicBearer: false, userAuthenticationBearer: bearer) { result, error in
            return resulting(result, error)
        }
    }
}
