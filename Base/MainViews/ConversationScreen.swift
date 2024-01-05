// Copyright 2023 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

//import GenerativeAIUIComponents
import GoogleGenerativeAI
import SwiftUI


struct ConversationScreen: View {
    @EnvironmentObject var viewModel: ConversationViewModel
    @State private var showingModelInfo = false
    
    @State private var userPrompt = ""
    
    enum FocusedField: Hashable {
        case message
    }
    
    @FocusState
    var focusedField: FocusedField?
    
    @FocusState private var isBeingUsed: Bool
    
    
    var body: some View {
        NavigationStack {
            VStack {
                
                ScrollView {
                    ScrollViewReader { scrollViewProxy in
                        
                        VStack(spacing: 8) {
                            //ConversationTile(event: event)
                            //ConversationTile(event: event)
                            VStack(spacing: 5) {
                                ForEach(viewModel.messages) { message in
                                    // Each message is in a blue rectangle with white text
                                    
                                    MessageBubble(message: message)
                                        .transition(.asymmetric(insertion: .scale, removal: .opacity))
                                    
                                    
                                }
                            }
                            .animation(.snappy(), value: viewModel.messages.count) // Trigger animation when message count changes
                            
                        }
                        .onChange(of: viewModel.messages, perform: { newValue in
                            guard let lastMessage = viewModel.messages.last else { return }
                            
                            // wait for a short moment to make sure we can actually scroll to the bottom
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                withAnimation {
                                    scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                                }
                                focusedField = .message
                            }
                        })
                    }
                    .navigationTitle("Gemini Pro")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                showingModelInfo = true
                            } label: {
                                Image(systemName: "info.circle")
                            }
                            
                        }
                    }
                }
                
                NavigationLink("",  destination: ModelInformationView(), isActive: $showingModelInfo)
                    .animation(.snappy(duration: 0.2), value: viewModel.messages)
                if viewModel.isLoading {
                    BouncingDots()
                        .frame(width: 100, height: 40)
                        .background(.blue)
                        .clipShape(Capsule())
                        //.cornerRadius(10)
                }
                Spacer()
                
                ZStack(alignment: .trailing) {
                    TextField("Message...", text: $userPrompt, axis: .vertical)
                        .focused($isBeingUsed)
                        .padding(12)
                        .padding(.trailing, 48)
                    //.background(Color(uiColor: .systemBackground))
                    //.clipShape(Capsule())
                        .glow(color: .blue, radius: 1)
                        .font(.subheadline)
                        .overlay {
                            RoundedRectangle(
                                cornerRadius: 8,
                                style: .continuous
                            )
                            .stroke(Color(UIColor.systemFill), lineWidth: 1)
                        }
                        .onSubmit {
                            sendOrStop()
                            hideKeyboard()
                        }
                    
                    
                    //.onSubmit(sendMessage) // Action when "Return" is pressed
                    //.submitLabel(.send)
                    //Spacer()
                    Button(action: {
                        isBeingUsed = false
                        sendOrStop()
                        // Action for the button
                        // Save chat history after sending a message
                        /*Task {
                         await viewModel.saveChatHistory()
                         }*/
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
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
            Task {
                await viewModel.saveChatHistory()
            }
        }
    }
    
    private func sendMessage() {
        Task {
            let prompt = userPrompt
            userPrompt = ""
            await viewModel.sendMessage(prompt, streaming: true)
        }
    }
    
    private func sendOrStop() {
        if viewModel.busy {
            viewModel.stop()
        } else {
            sendMessage()
        }
    }
    
    private func newChat() {
        viewModel.startNewChat()
    }
}

struct ConversationScreen_Previews: PreviewProvider {
    struct ContainerView: View {
        @StateObject var viewModel = ConversationViewModel()
        
        var body: some View {
            ConversationScreen()
                .environmentObject(viewModel)
                .onAppear {
                    viewModel.messages = ChatMessage.samples
                }
        }
    }
    
    static var previews: some View {
        NavigationStack {
            ConversationScreen()
        }
    }
}


#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

