//
//  ArrayExtension.swift
//  todo-online
//
//  Created by Majid Jamali on 1/18/25.
//

import Foundation
import SwiftUI

extension Array where Element == Date {
    
    func containedByDay(_ date: Date) -> Bool {
        let result = self.contains(where: { $0.isToday(date) })
        return result
    }
    
    mutating func insert(_ value: Element, ifCase expression: Bool) {
        if expression {
            self.append(value)
        }
    }
}
