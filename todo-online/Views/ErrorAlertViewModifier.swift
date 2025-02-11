//
//  ErrorAlertViewModifier.swift
//  todo-online
//
//  Created by Majid Jamali on 1/22/25.
//

import SwiftUI

struct ErrorAlertViewModifier: ViewModifier {
    @Binding var isShowing: Bool
    @Binding var error: ErrorResult?
    
    @EnvironmentObject var taskManager: TaskManager
    
    func body(content: Content) -> some View {
        content
            .alert(error?.message ?? "", isPresented: $isShowing) {
                Button("OK") {
                    withAnimation(.default) {
                        isShowing.toggle()
                        error = nil
                    }
                }
            }
    }
}
