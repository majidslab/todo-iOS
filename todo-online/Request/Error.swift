//
//  Error.swift
//  todo-online
//
//  Created by Majid Jamali on 1/22/25.
//

import Foundation

struct ErrorResult: Codable, LocalizedError {
    let message: String
    let error: String
    let statusCode: Int
}

extension ErrorResult {
    
    static let internetConnection = Self(message: "internet connection error", error: "no connection", statusCode: 0)
    static let emptyInputFields = Self(message: "insert all inputs required", error: "incomplete data", statusCode: -1)
}
