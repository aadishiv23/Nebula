//
//  BaseApp.swift
//  Base
//
//  Created by Aadi Shiv Malhotra on 12/17/23.
//

import SwiftUI
import Combine

@main
struct BaseApp: App {
    var body: some Scene {
        @State  var inp: String = ""

        WindowGroup {
            
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                ModelListView()
                    .tabItem {Label("User", systemImage: "list.bullet.clipboard")}
                ConversationScreen()
                    .tabItem {
                        Label("Temp", systemImage: "ellipsis.message.fill")
                    }
            }
            .environmentObject(ConversationViewModel())  // Injecting the view model
        }
    }
}

