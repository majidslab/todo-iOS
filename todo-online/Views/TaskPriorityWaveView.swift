//
//  TaskPriorityWaveView.swift
//  todo-online
//
//  Created by Majid Jamali on 1/21/25.
//

import SwiftUI

struct TaskPriorityWaveView: View {
    @Binding var priority: TaskModel.Priority
    var body: some View {
        HStack(spacing: 3.0) {
            Image(systemName: "wave.3.left", variableValue: Double(priority.rawValue) / Double(TaskModel.Priority.allCases.count))
            Text("Priority")
            Image(systemName: "wave.3.right", variableValue: Double(priority.rawValue) / Double(TaskModel.Priority.allCases.count))
        }
    }
}
