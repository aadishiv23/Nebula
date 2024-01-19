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
import PhotosUI


struct ConversationScreen: View {
    @EnvironmentObject var viewModel: ConversationViewModel
    @StateObject var photoViewModel = GeminiPhotoReasoningViewModel()
    @State private var showingModelInfo = false
    @State private var isShowingPhotoPicker = false
    @State private var userPrompt = ""
    
    enum FocusedField: Hashable {
        case message
    }
    
    @FocusState
    var focusedField: FocusedField?
    
    @FocusState private var isBeingUsed: Bool
    @FocusState private var isPhotoBeingUsed: Bool
    
    
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
                                    //.allowsHitTesting(true)
                                    
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
                
                HStack {
                    Button(action: {
                        isPhotoBeingUsed = false
                        isShowingPhotoPicker = true
                    }) {
                        Image(systemName: "camera")
                        //.resizable()
                        //.scaledToFit()
                            .frame(width: 20, height: 20) // Set the size as needed
                            .foregroundColor(.blue) // Set the color as needed
                            .padding()
                    }
                    .sheet(isPresented: $isShowingPhotoPicker) {
                        PhotosPicker(
                            selection: $photoViewModel.selectedItems,
                            matching: .images,
                            photoLibrary: .shared()) {
                                Text("Select Photo")
                            }
                    }
                    
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

extension ChatMessage {
    static var chatSample: [ChatMessage] {
        [
            ChatMessage(id: UUID().uuidString, content: "Hello, how can I help you today?", dateCreated: Date(), sender: .system),
            ChatMessage(id: UUID().uuidString, content: "I'm looking for information on SwiftUI.", dateCreated: Date(), sender: .user),
            ChatMessage(id: UUID().uuidString, content: "Sure! SwiftUI is a framework used to build user interfaces for all Apple platforms.", dateCreated: Date(), sender: .system)
        ]
    }
}

struct ConversationScreen_Previews: PreviewProvider {
    static var previews: some View {
        ConversationScreen()
            .environmentObject(previewViewModel())
    }
    
    static func previewViewModel() -> ConversationViewModel {
        let viewModel = ConversationViewModel()
        viewModel.messages = ChatMessage.samples // Use the static sample data
        // You can add more properties and configurations to the viewModel as needed for the preview
        return viewModel
    }
}


#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

