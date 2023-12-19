//
//  ContentView.swift
//  Base
//
//  Created by Aadi Shiv Malhotra on 12/17/23.
//

import SwiftUI

/// make work faster
extension Animation {
    static func ripple() -> Animation {
        Animation.spring()
    }
}

/// HWS
/// https://www.hackingwithswift.com/plus/swiftui-special-effects/shadows-and-glows
extension View {
    func glow(color: Color = .red, radius: CGFloat = 20) -> some View {
        self
            .overlay(self.blur(radius: radius / 6))
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
    }
}
let event = Event(title: "Buy Daisies", date: .now, location: "Flower Shop", symbol: "gift")

struct MessagesView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var messageText = ""
    @State private var messages: [String] = [] // Array to hold sent messages
    var modelName: String
    
    
    var body: some View {
        NavigationStack {
            /*VStack {
                Text("Chat")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(modelName)
                    .font(.footnote)
                    .foregroundColor(.white)
            }
            .frame(height: 56)
            .background(Color(UIColor.systemGray))
            .shadow(color: .gray.opacity(0.2), radius: 5)*/
            /* ZStack {
             ZStack {
             Image(systemName: "person.circle")
             .imageScale(.large)
             }
             
             Rectangle()
             .foregroundStyle(.teal)
             .ignoresSafeArea()
             .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height*0.08)
             VStack() {
             Text("Chat")
             .font(.title)
             .fontWeight(.bold)
             .fontDesign(.rounded)
             
             Text(modelName)
             .font(.footnote)
             .foregroundStyle(.gray)
             }
             
             }
             .background(Rectangle()
             .foregroundStyle(.teal)
             
             .frame(minWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height*0.1)
             .opacity(colorScheme == .dark ? 0.3 : 0.6)
             //.background(Color.gray.opacity(0.2)) // Gray background similar to iMessage
             
             )*/
            
            
            ScrollView {
                VStack(spacing: 8) {
                    //ConversationTile(event: event)
                    //ConversationTile(event: event)
                    VStack(spacing: 5) {
                        ForEach(messages, id: \.self) { message in
                            // Each message is in a blue rectangle with white text
                            MessageBubble(message: message)
                            //.transition(.asymmetric(insertion: .scale, removal: .opacity)) // Animation for message insertion and removal
                            
                        }
                    }
                }
            }
            .navigationTitle(modelName)
            .animation(.snappy(duration: 0.2), value: messages) // Apply animation when messages change
            //.animation(.spring(dampingFraction: 0.5))
            //.animation(.ripple())
            
            
            Spacer()
            
            ZStack(alignment: .trailing) {
                TextField("Message...", text: $messageText, axis: .vertical)
                    .padding(12)
                    .padding(.trailing, 48)
                    .background(Color(uiColor: .systemBackground))
                    .clipShape(Capsule())
                    .glow(color: .blue, radius: 1)
                    .font(.subheadline)
                
                
                //.onSubmit(sendMessage) // Action when "Return" is pressed
                //.submitLabel(.send)
                //Spacer()
                Button(action: {
                    sendMessage()
                    // Action for the button
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35) // Set the size as needed
                        .foregroundColor(.blue) // Set the color as needed
                        .padding()
                }
            }
            .padding(.horizontal)
        }
        .toolbar(.hidden, for: .tabBar)
        //.navigationBarHidden(true)
        //.navigationBarBackButtonHidden(true)
    }
    func sendMessage() {
        guard !messageText.isEmpty else { return } // Don't send empty messages
        withAnimation { // Wrap state changes in an animation block
            messages.append(messageText) // Append new message
        }
        messageText = "" // Clear the input field
    }
       
    
}


struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MessagesView(modelName: "Example")
                .preferredColorScheme(.light)
                .previewDisplayName("Light Mode")

            MessagesView(modelName: "Example")
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
