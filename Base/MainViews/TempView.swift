//
//  TempView.swift
//  Base
//
//  Created by Aadi Shiv Malhotra on 12/21/23.
//

import Foundation
import SwiftUI
import Combine

struct TempView: View {
    @State var chatMessages: [ChatMessage] = []
    @State private var messageText = ""
    @State private var showingModelInfo = false
    @State private var messages: [ChatMessage] = []
    @State private var cancellables = Set<AnyCancellable>()
    
    let openAIService = OpenAIService()
    
    let modelName = "GPT"
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 8) {
                    //ConversationTile(event: event)
                    //ConversationTile(event: event)
                    VStack(spacing: 5) {
                        ForEach(messages) { message in
                            // Each message is in a blue rectangle with white text
                            MessageBubble(message: message)
                                .transition(.asymmetric(insertion: .scale, removal: .opacity))
                            
                            
                        }
                    }
                    .animation(.snappy(), value: messages.count) // Trigger animation when message count changes
                    
                }
            }
            .padding()
            .navigationTitle(modelName)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingModelInfo = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    
                }
            }
            NavigationLink("",  destination: ModelInformationView(), isActive: $showingModelInfo)
            .animation(.snappy(duration: 0.2), value: messages)
            
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
    }
    func sendMessage() {
        /*guard !messageText.isEmpty else { return }
         let newMessage = ChatMessage(content: messageText)
         withAnimation(.snappy(duration: 0.2)) {
         messages.append(newMessage)
         }*/
        let myMessage = ChatMessage(id: UUID().uuidString, content: messageText, dateCreated: Date(), sender: .user)
        messages.append(myMessage)
        openAIService.sendModel(message: messageText).sink { completion in
            // handle error
        } receiveValue: { response in
            guard let textResponse = response.choices.first?.text else { return }
            let gptMessage = ChatMessage(id: response.id, content: textResponse, dateCreated: Date(), sender: .gpt)
            messages.append(gptMessage)
        }
        .store(in: &cancellables)
        
        messageText = ""
    }
    
    func openAISendMessage() {
        openAIService.sendModel(message: messageText).sink { completion in
            // handle error
        } receiveValue: { response in
            guard let textResponse = response.choices.first?.text else { return }
            let gptMessage = ChatMessage(id: response.id, content: textResponse, dateCreated: Date(), sender: .gpt)
        }
        .store(in: &cancellables)
        
        messageText = ""
    }
}


struct TempView_Previews: PreviewProvider {
    // static var cancellables: Set<AnyCancellable>
    static var previews: some View {
        TempView()
            .preferredColorScheme(.light)
            .previewDisplayName("Light Mode")
    }
}
