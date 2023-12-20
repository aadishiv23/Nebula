//
//  ConversationDisplayView.swift
//  Base
//
//  Created by Aadi Shiv Malhotra on 12/17/23.
//

import Foundation
import SwiftUI

struct Event: Hashable {
    let title: String
    let date: Date
    let location: String
    let symbol: String
}


struct ConversationTile: View {
    let event: Event
    let stripeHeight = 15.0
    @State private var rate = 1.0

    @State private var isSelected = false
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(systemName: event.symbol)
                .font(.title)
                .padding([.top, .leading]) // Padding to move the image to the top left
                .rotationEffect(isSelected ? .degrees(15) : .zero)
            
            VStack {
                Spacer() // Pushes content to the bottom
                Text(event.title)
                    .font(.title2)
                    .lineLimit(1)
                    .padding([.leading, .bottom]) // Padding for the title
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
        .scaleEffect(isSelected ? 1.2 : 1.0)
        .gesture(
                TapGesture()
                    .onEnded { _ in
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isSelected = true
                        }
                        withAnimation(Animation.easeInOut(duration: 0.2).repeatCount(5, autoreverses: true)) {
                            // Jiggle effect
                        }
                        withAnimation(Animation.easeInOut(duration: 0.2).delay(0.2)) {
                            isSelected = false
                        }
                    }
            )
        .padding()
        .background{
            ZStack(alignment: .bottom) {
                Rectangle()
                    .frame(width: 200, height: 200)
                    .opacity(0.3)
                    .mask(RoundedRectangle(cornerRadius: stripeHeight))
                Rectangle()
                    .frame(width: 200, height: 200/5)
                    
            }
            .foregroundStyle(.teal)
        }
        .scaleEffect(isSelected ? 1.1 : 1.0)
        // .animation(.spring, value: rate)
        .frame(width: 170, height: 170, alignment: .center).cornerRadius(15).shadow(radius: 20).padding(20)
        
    }
}


struct ConversationTile_Preview: PreviewProvider {
    static let event = Event(title: "Buy Daisies", date: .now, location: "Flower Shop", symbol: "gift")
    
    static var previews: some View {
        ConversationTile(event: event)
    }
}
