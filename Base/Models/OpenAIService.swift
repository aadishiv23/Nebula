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
    let baseurl = "https://api.openai.com/v1/"
    
    func sendModel(message: String) -> AnyPublisher<OpenAICompletionsResponse, Error> {
        let completion  = OpenAICompletions(model: "text-davinci-003", prompt: message, temp: 0.7)
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(Constants.openAIAPIKey)"
        ]
        
        return Future { [weak self] promise in
            guard let self = self else { return }
            AF.request(self.baseurl + "completions", method: .post, parameters: completion, encoder: .json, headers: headers).responseDecodable(of: OpenAICompletionsResponse.self) {response in
                switch response.result {
                case .success(let result):
                    promise(.success(result))
                case .failure(let error):
                    print("Failure ")
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

struct OpenAICompletions : Encodable {
    let model: String
    let prompt: String
    let temp: Float
    
}

// decode from req

struct OpenAICompletionsResponse: Decodable {
    let id: String
    let choices: [OpenAICompletionsChoices]
}

struct OpenAICompletionsChoices: Decodable {
    let text: String
}
