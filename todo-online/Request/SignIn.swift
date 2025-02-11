//
//  SignIn.swift
//  todo-online
//
//  Created by Majid Jamali on 1/21/25.
//

import Foundation

struct SignInResult: Codable {
    var token: String
}

struct SignInBody: Codable {
    var username: String
    var password: String
}
