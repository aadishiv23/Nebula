//
//  HomeView.swift
//  Base
//
//  Created by Aadi Shiv Malhotra on 12/17/23.
//

import Foundation
import SwiftUI

let array: [Event] = [
    Event(title: "Buy Daisies", date: .now, location: "Flower Shop", symbol: "gift"),
    Event(title: "Buy Roses", date: .now, location: "Flower Shop", symbol: "gift"),
    Event(title: "Buy Chicken", date: .now, location: "Flower Shop", symbol: "gift"),
    Event(title: "Buy Daisies", date: .now, location: "Flower Shop", symbol: "gift")
]

let columns = [
    GridItem(.flexible(), spacing: 5),
    GridItem(.flexible(), spacing: 5)
]

struct HomeView: View {
    @State private var showingSettings = false //  control navigation

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(array, id: \.self) {el in
                        ConversationTile(event: el)
                            .padding(.horizontal, 10)
                            //.frame(height: 100)
                            //.background(Color.gray.opacity(0.2)) // debug
                    }
                }
                .padding(.vertical)
                .padding(.horizontal)
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showingSettings = true // Activate the link when the button is tapped
                    }) {
                        Image(systemName: "gear") // Gear icon
                    }

                }
            }
        }
    }
}

#Preview {
    HomeView()
}
