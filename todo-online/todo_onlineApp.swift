//
//  todo_onlineApp.swift
//  todo-online
//
//  Created by Majid Jamali on 1/15/25.
//

import SwiftData
import SwiftUI

@main
struct todo_onlineApp: App {
    
    @ObservedObject private var taskManager = TaskManager()
    
    let configurations = ModelConfiguration(schema: Schema([UserModel.self]))
    let path = URL.documentsDirectory.appending(path: "users.store")
    let context: ModelContext
    
    init() {
        let container = try! ModelContainer(for: UserModel.self, configurations: configurations)
        context = ModelContext(container)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(taskManager)
        }
        .modelContext(context)
    }
}
