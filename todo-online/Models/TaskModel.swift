//
//  TaskModel.swift
//  todo-online
//
//  Created by Majid Jamali on 1/21/25.
//

import Foundation
import SwiftData

@Model
class TaskModel {
    var id: String
    var itemId: Int
    var title: String
    var subtitle: String
    var details: String
    var category: Category.RawValue
    var priority: Priority.RawValue
    var dueDate: Date
    var dueDateString: String // dd-mm-yyyy
    var isDone: Bool
    var userData: String?
    var createdDate: Date?
    var lastUpdated: Date?
    
    var categoryValue: Category {
        Category(rawValue: self.category) ?? .routine
    }
    
    var priorityValue: Priority {
        Priority(rawValue: self.priority) ?? .low
    }
    
    init(id: String = UUID().uuidString, itemId: Int, title: String = "", subtitle: String = "", details: String = "", category: Category.RawValue = 1, priority: Priority.RawValue = 1, dueDate: Date = .now, dueDateString: String = "", isDone: Bool = false, userData: String? = nil, createdDate: Date? = nil, lastUpdated: Date? = nil) {
        
        self.id = id
        self.itemId = itemId
        self.title = title
        self.subtitle = subtitle
        self.details = details
        self.category = category
        self.priority = priority
        self.dueDate = dueDate
        self.dueDateString = dueDateString
        self.isDone = isDone
        self.userData = userData
        self.createdDate = createdDate
        self.lastUpdated = lastUpdated
    }
    
    enum Category: Int, CaseIterable {
        case routine = 1
        case work, selfCare, familyTime
        
        func getTitle() -> String {
            return switch self {
            case .routine:
                "routine"
            case .work:
                "work"
            case .selfCare:
                "self care"
            case .familyTime:
                "family time"
            }
        }
    }
    
    enum Priority: Int, CaseIterable {
        case low = 1
        case mid, high
        
        func getTitle() -> String {
            return switch self {
            case .low:
                "low"
            case .mid:
                "medium"
            case .high:
                "high"
            }
        }
    }
}

extension TaskModel {
    
    func isTimeOver() -> Bool {
        return dueDate < Date.now
    }
    
    func isNotOver() -> Bool {
        return dueDate >= Date.now
    }
}
