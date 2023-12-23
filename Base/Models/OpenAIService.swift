//
//  OpenAISerivce.swift
//  Base
//
//  Created by Aadi Shiv Malhotra on 12/21/23.
//

import Foundation
import Alamofire
import Combine

class OpenAIService {
    // for newer gpt-4, gpt-3.5-turbo
    //"https://api.openai.com/v1/chat/completions"
    private let endpointURL = "https://api.openai.com/v1/chat/completions"
    
    func sendModel(messages: [ChatMessage]) async -> OpenAIChatResponse? {
        // conv from chatmessage to openai
        let openAIMessages = messages.map({OpenAIChatMessage(role: $0.sender, content: $0.content)})
        let body = OpenAIChatBody(model: "gpt-3.5-turbo", messages: openAIMessages)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constants.openAIAPIKey)"
        ]
        return try? await AF.request(endpointURL, method: .post, parameters: body, encoder: .json, headers: headers).serializingDecodable(OpenAIChatResponse.self).value
    }
}

struct OpenAIChatBody : Encodable {
    let model: String
    let messages: [OpenAIChatMessage]
}

struct OpenAIChatMessage: Codable {
    let role: MessageSender
    let content: String
}

struct OpenAIChatResponse: Decodable {
    let choices: [OpenAIChatChoice]
}

struct OpenAIChatChoice: Decodable {
    let message: OpenAIChatMessage
}
