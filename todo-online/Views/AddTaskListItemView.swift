//
//  AddTaskListItemView.swift
//  todo-online
//
//  Created by Majid Jamali on 1/21/25.
//

import SwiftUI

struct AddTaskListItemView: View {
    let title: String
    @ViewBuilder let view: any View
    var body: some View {
        VStack(alignment: .leading,spacing: 4.0) {
            Text(title)
                .font(.caption)
            AnyView(view)
        }
        .listRowSeparatorTint(.clear)
    }
}
