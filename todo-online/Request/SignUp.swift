//
//  SignUp.swift
//  todo-online
//
//  Created by Majid Jamali on 1/22/25.
//

import Foundation

struct SignUpResult: Codable {
    var token: String
}

struct SignUpBody: Codable {
    var fullName: String
    var username: String
    var password: String
}
