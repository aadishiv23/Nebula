//
//  ConversationViewModel.swift
//  Base
//
//  Created by Aadi Shiv Malhotra on 12/22/23.
//

import Foundation
import GoogleGenerativeAI
import UIKit

@MainActor
class ConversationViewModel: ObservableObject {
    /// Array to hold user's and message recipient's messages (system/gpt)
    @Published var messages = [ChatMessage]()
    private let historyFilename = "chat_history.json"
    
    /// Indicates whether waiting for model to finish
    @Published var busy = false
    @Published var isLoading: Bool = false
    @Published var error: Error?
    var hasError: Bool {
        return error != nil
    }
    
    private var model: GenerativeModel
    private var chat: Chat
    private var stopGenerating = false
    
    private var chatTask: Task<Void, Never>?
    
    init() {
        model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
        chat = model.startChat()
        //Task { awaitloadChatHistory() }// from memory
    }
    
    func sendMessage(_ text: String, streaming: Bool = true) async {
        error = nil
        self.isLoading = true
        print("isloading =  true")
        if streaming {
            await internalSendMessageStreaming(text)
        }
        else {
            await internalSendMessage(text)
        }
    }
    
    func startNewChat() {
        stop()
        error = nil
        chat = model.startChat()
        messages.removeAll()
    }
    
    func stop() {
        chatTask?.cancel()
        error = nil
    }
    
    private func internalSendMessageStreaming(_ text: String) async {
        chatTask?.cancel()
        
        chatTask = Task {
            busy = true
            defer {
                busy = false
            }
            
            /// Add user message to chat
            let userMessage = ChatMessage(id: UUID().uuidString, content: text, dateCreated: Date(), sender: .user)
            messages.append(userMessage)
            
            // add a pending message while awaiting response
           // let systemMessage = ChatMessage.pending(sender: .system)
            //messages.append(systemMessage)
            
            do {
                /*let responseStream = chat.sendMessageStream(text)
                 for try await chunk in responseStream {
                 messages[messages.count - 1].pending = false
                 if let text = chunk.text {
                 messages[messages.count - 1].content += text
                 }
                 }*/
                var response: GenerateContentResponse?
                response = try await chat.sendMessage(text)
                
                if let responseText = response?.text {
                    // Add system message after receiving the response
                    let systemMessage = ChatMessage(id: UUID().uuidString, content: responseText, dateCreated: Date(), sender: .system)
                    messages.append(systemMessage)
                }
                self.isLoading = false
            } catch {
                self.error = error
                print(error.localizedDescription)
                messages.removeLast()
            }
        }
    }
    
    private func internalSendMessage(_ text: String) async {
        chatTask?.cancel()
        
        chatTask = Task {
            busy = true
            defer {
                busy = false
            }
            
            /// Add user message to chat
            let userMessage = ChatMessage(id: UUID().uuidString, content: text, dateCreated: Date(), sender: .user)
            messages.append(userMessage)
            
            // add a pending message while awaiting response
            let systemMessage = ChatMessage.pending(sender: .system)
            messages.append(systemMessage)
            
            do {
                var response: GenerateContentResponse?
                response = try await chat.sendMessage(text)
                
                if let responseText = response?.text {
                    // replace pending message with backend response
                    messages[messages.count - 1].content = responseText
                    messages[messages.count - 1].pending = false
                }
                self.isLoading = false
            } catch {
                self.error = error
                print(error.localizedDescription)
                messages.removeLast()
            }
        }
    }
    
    // Save chat history to file
    func saveChatHistory() async {
        do {
            let data = try JSONEncoder().encode(messages)
            let fileURL = getDocumentDirectory().appendingPathComponent(historyFilename)
            try data.write(to: fileURL)
        } catch {
            print("Error saving chat history: \(error)")
        }
    }
    
    // Load chat history
    func loadChatHistory() async {
        do {
            let fileURL = getDocumentDirectory().appendingPathComponent(historyFilename)
            let data = try Data(contentsOf: fileURL)
            messages = try JSONDecoder().decode([ChatMessage].self, from: data)
        } catch {
            print("Error saving chat history: \(error)")
        }
    }
    
    private func getDocumentDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
}
