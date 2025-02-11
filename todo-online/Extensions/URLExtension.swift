//
//  URLExtension.swift
//  todo-online
//
//  Created by Majid Jamali on 1/21/25.
//

import Foundation

extension URL {
    
    static func todoPatchbyAdditiveURL(byAdding string: String, to url: URL?) -> URL? {
        guard let url else {
            return nil
        }
        return url.appending(path: string)
    }
    
    static func todoDeletebyAdditiveURL(byAdding id: Int, to url: URL?) -> URL? {
        guard let url else {
            return nil
        }
        return url.appending(path: "\(id)")
    }
    
    static let publicBearerToken = "AAAAAAAAAA.BBBBBBBBBBB.CCCCCCCCCCC"
    
    static let signinPOST = URL(string: "https://o-1.ir/todolist/v1/user/signin")
    static let signupPOST = URL(string: "https://o-1.ir/todolist/v1/user/signup")
    static let profileGET = URL(string: "https://o-1.ir/todolist/v1/user/profile")
    
    static let todoPOST = URL(string: "https://o-1.ir/todolist/v1/todo")
    static let todoGET = URL(string: "https://o-1.ir/todolist/v1/todo")

}
