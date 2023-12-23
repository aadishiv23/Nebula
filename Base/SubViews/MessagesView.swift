//
//  ContentView.swift
//  Base
//
//  Created by Aadi Shiv Malhotra on 12/17/23.
//

import SwiftUI
import Combine
/// make work faster
extension Animation {
    static func ripple() -> Animation {
        Animation.spring()
    }
}

extension Animation {
    static func snappy() -> Animation {
        Animation.spring(response: 0.6, dampingFraction: 0.5, blendDuration: 0.5)
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
    @State private var showingModelInfo = false
    @State private var messages: [ChatMessage] = []
    @State private var cancellables = Set<AnyCancellable>()
    
    let openAIService = OpenAIService()
    
    var modelName: String
    
    
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
            // Apply animation when messages change
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
                    Task {
                        // want to change
                        await sendMessage()
                        
                    }
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
    func sendMessage() async{
        let newMessage = ChatMessage(id: UUID().uuidString, content: messageText, dateCreated: Date(), sender: .user)
        messages.append(newMessage)
        messageText = ""
        
        Task {
            let response = await openAIService.sendModel(messages: messages)
            guard let receivedOpenAIMessage = response?.choices.first?.message else {
                print("no received message")
                return
            }
            let receivedMessage = ChatMessage(id: UUID().uuidString, content: receivedOpenAIMessage.content, dateCreated: Date(), sender: receivedOpenAIMessage.role)
            // running on background thread but want to add on amin
            // network call on bg thread
            // message call on main
            await MainActor.run {
                messages.append(receivedMessage)
                
            }
        }
    }
    
    
    
}


struct ChatMessage: Identifiable, Equatable, Decodable {
    let id: String
    var content: String
    let dateCreated: Date
    let sender: MessageSender
    
    var pending = false
    
    static func pending(sender: MessageSender) -> ChatMessage {
        Self(id: UUID().uuidString, content: "", dateCreated: Date(), sender: sender, pending: true)
    }
}

extension ChatMessage {
  static var samples: [ChatMessage] = [
    .init(id: UUID().uuidString, content: "Hello. What can I do for you today?", dateCreated: Date(), sender: .system),
    .init(id: UUID().uuidString, content: "Show me a simple loop in Swift.", dateCreated: Date(), sender: .user),
    .init(id: UUID().uuidString, content: """
    Sure, here is a simple loop in Swift:

    # Example 1
    ```
    for i in 1...5 {
      print("Hello, world!")
    }
    ```

    This loop will print the string "Hello, world!" five times. The for loop iterates over a range of numbers,
    in this case the numbers from 1 to 5. The variable i is assigned each number in the range, and the code inside the loop is executed.

    **Here is another example of a simple loop in Swift:**
    ```swift
    var sum = 0
    for i in 1...100 {
      sum += i
    }
    print("The sum of the numbers from 1 to 100 is \\(sum).")
    ```

    This loop calculates the sum of the numbers from 1 to 100. The variable sum is initialized to 0, and then the for loop iterates over the range of numbers from 1 to 100. The variable i is assigned each number in the range, and the value of i is added to the sum variable. After the loop has finished executing, the value of sum is printed to the console.
    """, dateCreated: Date(), sender: .system),
  ]

  static var sample = samples[0]
}

enum MessageSender: String, Codable {
    case system
    case user
    case gpt
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
