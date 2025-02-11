//
//  Delete.swift
//  todo-online
//
//  Created by Majid Jamali on 1/29/25.
//

struct DeleteResult: Codable {
    var id: Int
    var title: String
    var description: String
    var isCompleted: Bool
}

struct DeleteBody: Codable {
    var id: Int
}
