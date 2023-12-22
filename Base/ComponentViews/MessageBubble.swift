//
//  MessageBubble.swift
//  Base
//
//  Created by Aadi Shiv Malhotra on 12/18/23.
//

import Foundation
import SwiftUI

/*struct MessageBubble: View {
 @State  var message: ChatMessage
 var body: some View {
 Text(message.content)
 .foregroundColor(.white)
 .padding()
 .background(Color.blue)
 .clipShape(MessageBubbleShape())
 .frame(maxWidth: .infinity, alignment: .trailing) // Messages aligned to the right
 .padding()
 }
 }*/
struct MessageBubble: View {
    var message: ChatMessage
    
    func bubbleShape(for sender: MessageSender) -> some Shape {
        switch sender {
        case .user:
            return AnyShape(MessageBubbleShapeUser())
        case .gpt:
            return AnyShape(MessageBubbleShapeGPT())
        }
    }
    var body: some View {
        
        HStack {
            if message.sender == .user { Spacer() }
            Text(message.content)
                .foregroundColor(message.sender == .user ? .white : .black)
                .padding()
                .background(message.sender == .user ? .blue : .gray.opacity(0.1))
                .clipShape(bubbleShape(for: message.sender))
                .frame(maxWidth: .infinity, alignment: message.sender == .user ? .trailing : .leading) // Messages aligned to the right
                .padding()
            if message.sender == .gpt { Spacer() }
        }
    }
    
}

extension MessageBubble {
    static let sampleMessages = [
        ChatMessage(id: UUID().uuidString, content: "Sample message", dateCreated: Date(), sender: .user),
        ChatMessage(id: UUID().uuidString, content: "Sample message", dateCreated: Date(), sender: .user),
        ChatMessage(id: UUID().uuidString, content: "Sample message", dateCreated: Date(), sender: .user),
        
    ]
}

struct MessageBubbleShapeUser: Shape {
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [
            .topLeft,
            .topRight,
            .bottomLeft
        ], cornerRadii: CGSize(width: 16, height: 16))
        return Path(path.cgPath)
    }
}

struct MessageBubbleShapeGPT: Shape {
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [
            .topLeft,
            .topRight,
            .bottomRight
        ], cornerRadii: CGSize(width: 16, height: 16))
        return Path(path.cgPath)
    }
}

struct MessageBubbleShape_Previews: PreviewProvider {
    
    static let sampleMessages = [
        ChatMessage(id: UUID().uuidString, content: "Roink message", dateCreated: Date(), sender: .user),
        ChatMessage(id: UUID().uuidString, content: "Boink", dateCreated: Date(), sender: .gpt),
        ChatMessage(id: UUID().uuidString, content: "Twoik message", dateCreated: Date(), sender: .user),
        
    ]
    static var previews: some View {
        MessageBubble(message: sampleMessages[0])
        Spacer()
        MessageBubble(message: sampleMessages[1])
    }
}


struct AnyShape: Shape {
    private let _path: (CGRect) -> Path
    
    init<S: Shape>(_ wrapped: S) {
        _path = { rect in
            let path = wrapped.path(in: rect)
            return path
        }
    }
    
    func path(in rect: CGRect) -> Path {
        _path(rect)
    }
}
