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
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium // for example: Jan 8, 2024
        formatter.timeStyle = .short // for example: 12:00 AM
        return formatter
    }()
    
    var body: some View {
        List(viewModel.messages, id: \.id) { message in
            VStack(alignment: .leading) {
                Text(message.content)
                    .padding()
                Text(dateFormatter.string(from: message.dateCreated))
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
