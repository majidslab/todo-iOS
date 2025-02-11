//
//  AddTaskPreview.swift
//  todo-online
//
//  Created by Majid Jamali on 1/21/25.
//

import SwiftUI

struct AddTaskPreview: View {
    
    @Binding var title: String
    @Binding var subtitle: String
    @Binding var details: String
    @Binding var category: TaskModel.Category
    @Binding var priority: TaskModel.Priority
    @Binding var dueDate: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            Spacer(minLength: 4.0)
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
            }
            Spacer(minLength: 2.0)
            Text(subtitle)
                .font(.subheadline)
                .opacity(0.75)
            Spacer(minLength: 18.0)
            HStack {
                HStack(spacing: 4.0) {
                    Image(systemName: "square.3.layers.3d.top.filled")
                    Text(category.getTitle().capitalized)
                }
                .padding(.horizontal, 8.0)
                .padding(.vertical, 4.0)
                .background(
                    Capsule()
                        .strokeBorder(lineWidth: 3.0, antialiased: true)
                        .foregroundStyle(Color.selectedDateBG.gradient)
                )
                .font(.caption)
                Spacer(minLength: 4.0)
                HStack(spacing: 4.0) {
                    TaskPriorityWaveView(priority: $priority)
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
                    Text(dueDate.getMonth() + " " + dueDate.getDay())
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
                    Text(dueDate.formatted(date: .omitted, time: .shortened))
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
        
    }
}
