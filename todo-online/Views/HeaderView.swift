//
//  HeaderView.swift
//  todo-online
//
//  Created by Majid Jamali on 1/16/25.
//

import SwiftUI

struct HeaderView: View {
    let title: String
    let canNavigateBack: Bool
    let onBackButtonTapped: () -> Void
    var body: some View {
        
        ZStack(alignment: .leading) {
            if canNavigateBack {
                Button {
                    onBackButtonTapped()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.headline)
                }
                .buttonStyle(.plain)
            }
            HStack(alignment: .center) {
                Spacer()
                Text(title)
                    .fontDesign(.rounded)
                    .font(.title2.smallCaps())
                Spacer()
            }
        }
        .padding(16)
    }
}

#Preview {
    ContentView()
}
