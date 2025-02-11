//
//  UserProfileView.swift
//
//  Created by Majid Jamali with ❤️ on 2/11/25.
//  
//  

import SwiftUI
import SwiftData

struct UserProfileView: View {
    
    @State private var name: String = ""
    @State private var username: String = ""
    
    @Query var users: [UserModel]
    
    @State private var profileResult: ProfileResult?
    
    var body: some View {
        VStack {
            Image(systemName: "person.circle")
                .font(.largeTitle)
                .padding(.top, 24.0)
            List {
                AddTaskListItemView(title: "full name") {
                    if let profileResult {
                        Text(profileResult.fullName)
                    } else {
                        ProgressView().progressViewStyle(.circular)
                    }
                }
                AddTaskListItemView(title: "user name") {
                    Text(users.first?.userName ?? "")
                        .springLoadingBehavior(.enabled)
                }
                AddTaskListItemView(title: "online tasks") {
                    if let profileResult {
                        Text("\(profileResult.todoCount)")
                    } else {
                        ProgressView().progressViewStyle(.circular)
                    }
                }
                AddTaskListItemView(title: "done tasks") {
                    Text("\(users.first?.tasks?.count(where: { $0.isDone }) ?? 0)")
                }
                
                AddTaskListItemView(title: "unsynced tasks") {
                    Text("\(users.first?.tasks?.count(where: { $0.itemId == -1 }) ?? 0)")
                }
            }
        }
        .onAppear {
            getUserProfileOnline()
        }
    }
    
    func getUserProfileOnline() {
        let networkManager = NetworkManager()
        networkManager.request(ProfileResult.self, url: URL.profileGET, method: .get, requestBody: nil, isPublicBearer: false, userAuthenticationBearer: users.first?.accessToken) { result, error in
            
            profileResult = result
            users.first?.fullName = result?.fullName
        }
    }
}
