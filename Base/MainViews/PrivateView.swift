//
//  Private.swift
//  Base
//
//  Created by Aadi Shiv Malhotra on 1/4/24.
//

import Foundation
import SwiftUI

struct PrivateView: View {
    @EnvironmentObject var viewModel: ConversationViewModel
    
    var body: some View {
        List(viewModel.messages, id: \.id) { message in
            VStack(alignment: .leading) {
                Text(message.content)
                    .padding()
                Text(message.dateCreated, style: .date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .onAppear {
            // Load chat history when the view appears
            Task {
                await viewModel.loadChatHistory()
            }
        }
    }
}
