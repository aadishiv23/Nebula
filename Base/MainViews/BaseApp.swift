//
//  BaseApp.swift
//  Base
//
//  Created by Aadi Shiv Malhotra on 12/17/23.
//

import SwiftUI

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
                    .tabItem {Label("User", systemImage: "list.bullet.clipboard") }
            }
        }
    }
}

