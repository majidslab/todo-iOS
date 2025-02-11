//
//  Task.swift
//  todo-online
//
//  Created by Majid Jamali on 1/22/25.
//

import Foundation

struct TaskResult: Codable {
    var id: Int
    var title: String
    var description: String
    var isCompleted: Bool
}

struct TaskBody: Codable {
    var title: String
    var description: String
    var isCompleted: Bool
}
