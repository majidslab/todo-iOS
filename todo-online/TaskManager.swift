//
//  TaskManager.swift
//  todo-online
//
//  Created by Majid Jamali on 1/18/25.
//

import SwiftUI
import SwiftData

final class TaskManager: NSObject, ObservableObject {
    
    @Published var continueAsOffline = false
    
    @Published var selectedDate = Date.now
    @Published var shouldShowToday = false
    @Published var showJustTaskDays: Bool = false
    
    @Published var showAddView = false
    @Published var presentationDetent: PresentationDetent = .medium
    
    @Published var showUserLogin: Bool = false
    
    @Published var showUserProfile: Bool = false
    
    func getAll(_ userToken: String?, resulting: @escaping (([TaskResult]?, ErrorResult?)->Void) ) {
        let networkManager = NetworkManager()
        let bearer = userToken
        
        networkManager.groupResultingRequest([TaskResult].self, url: URL.todoGET, method: .get, requestBody: nil, isPublicBearer: false, userAuthenticationBearer: bearer) { results, error in
            
            return resulting(results, error)
        }
    }
}
