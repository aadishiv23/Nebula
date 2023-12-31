//
//  ChatHistoryView.swift
//  Base
//
//  Created by Aadi Shiv Malhotra on 12/31/23.
//

import Foundation
import SwiftUI

let sampleHistory = [
    ChatHistory(title: "1st", dateCreated: .now, model: "GPT-3"),
    ChatHistory(title: "2nd", dateCreated: .now, model: "GPT-4"),
    ChatHistory(title: "3rd", dateCreated: .now, model: "Gemini")
]

struct ChatHistoryView: View {
    @State private var hist = sampleHistory[0]
    var body: some View {
        VStack(alignment: .leading) {
            Text(hist.title)
                .bold()
                .fontWeight(.black)
            HStack {
                Text(hist.model)
                
            }
        }
        .frame(maxWidth: UIScreen.main.bounds.width * (0.8), alignment: .leading) // Align text to the left
        .padding() // padding inside rect
        .background(Color.gray.opacity(0.155)) // bg color of the rectangle to gray
        .foregroundColor(.black) 
        .cornerRadius(10) // round
        .shadow(color: .red, radius: 10, x: 5, y: 5) // Better shadow than just 5
        .padding([.leading, .trailing], 10) // Edge padding
    }
}


struct ChatHistory: Identifiable {
    var id = UUID()
    var title: String
    var dateCreated: Date
    var model: String
}


struct ChatHistoryView_Preview: PreviewProvider {
    
    static var previews: some View {
        ForEach(sampleHistory) { hist in
            ChatHistoryView()
        }
    }
}
