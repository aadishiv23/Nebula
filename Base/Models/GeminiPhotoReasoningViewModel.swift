//
//  GeminiPhotoReasoningViewModel.swift
//  Base
//
//  Created by Aadi Shiv Malhotra on 1/10/24.
//

import Foundation
import GoogleGenerativeAI
import OSLog
import SwiftUI
import PhotosUI

@MainActor
class GeminiPhotoReasoningViewModel: ObservableObject {
    private var logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "generative-ai")
    
    @Published
    var userInput: String = ""
    
    @Published
    var selectedItems = [PhotosPickerItem]()
    
    @Published
    var outputText: String? = nil
    
    
    @Published
    var errorMessage: String?
    
    @Published
    var inProgress = false
    
    private var model: GenerativeModel?
    
    init() {
        model = GenerativeModel(name: "gemini-pro-vision", apiKey: APIKey.default)
    }
}
