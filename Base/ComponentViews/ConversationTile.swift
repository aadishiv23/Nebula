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
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Image(systemName: event.symbol)
                .font(.title)
            VStack(alignment: .leading) {
                Text(event.title)
                    .font(.title)
                    .lineLimit(1)
                Text(
                    event.date,
                    format: Date.FormatStyle()
                        .day(.defaultDigits)
                        .month(.wide)
                )
                Text(event.location)
            }
        }
        .padding()
        .padding(.bottom, stripeHeight)
        .background{
            ZStack(alignment: .bottom) {
                Rectangle()
                    .frame(maxHeight: stripeHeight)
                Rectangle()
                    .frame(width: 200, height: 200)
                    .opacity(0.3)
               
            }
            .foregroundStyle(.teal)
        }
        .clipShape(RoundedRectangle(cornerRadius: stripeHeight, style: .continuous))
        .frame(width: 200, height: 200, alignment: .center)
    }
}


struct ConversationTile_Preview: PreviewProvider {
    static let event = Event(title: "Buy Daisies", date: .now, location: "Flower Shop", symbol: "gift")

    static var previews: some View {
        ConversationTile(event: event)
    }
}
