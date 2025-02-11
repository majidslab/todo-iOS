//
//  UserModel.swift
//  todo-online
//
//  Created by Majid Jamali on 1/16/25.
//

import Foundation
import SwiftData

@Model
class UserModel {
    
    var id: String = UUID().uuidString
    var name: String?
    var family: String?
    var fullName: String?
    var profileImage: String?
    var gmail: String?
    var userName: String?
    var password: String?
    var gmailToken: String?
    var lastLogin: Date?
    var accessToken: String?
    var registrationDate: Date?
    
    @Relationship(deleteRule: .cascade, minimumModelCount: 0, originalName: "task") var tasks: [TaskModel]?
    
    init(name: String? = "", family: String? = "", fullName: String? = "", profileImage: String? = "", gmail: String? = "", userName: String? = "", password: String? = "", gmailToken: String? = "", lastLogin: Date? = .now, accessToken: String? = "", registrationDate: Date? = nil) {
        self.name = name
        self.family = family
        self.fullName = fullName
        self.profileImage = profileImage
        self.gmail = gmail
        self.userName = userName
        self.password = password
        self.gmailToken = gmailToken
        self.lastLogin = lastLogin
        self.accessToken = accessToken
        self.registrationDate = registrationDate
    }
}
