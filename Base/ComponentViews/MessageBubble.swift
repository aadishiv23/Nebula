//
//  MessageBubble.swift
//  Base
//
//  Created by Aadi Shiv Malhotra on 12/18/23.
//

import Foundation
import SwiftUI

struct MessageBubble: View {
    @State  var message: String
    var body: some View {
        Text(message)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .clipShape(MessageBubbleShape())
            .frame(maxWidth: .infinity, alignment: .trailing) // Messages aligned to the right
            .padding()
    }
}


struct MessageBubbleShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [
            .topLeft,
            .topRight,
            .bottomLeft
        ], cornerRadii: CGSize(width: 16, height: 16))
        return Path(path.cgPath)
    }
}

struct MessageBubbleShape_Previews: PreviewProvider {
    static var previews: some View {
        MessageBubbleShape()
    }
}
