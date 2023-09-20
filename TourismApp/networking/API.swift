//
//  File.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 13/08/23.
//

import Foundation
import Alamofire

let BASE_URL = "http://127.0.0.1:8080"
let testToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2OTc4Mjk4MjYsInVzZXIiOiJhc2xvbiJ9.Z3izRBnwzCFOZkF2g7gUh8MKUrVzIrDDcB83ic2srcU"

class API {
    static let shared = API()
    
    let API_URL_OPEN_CHAT = BASE_URL + "/chat/open_chat"
    let API_URL_QUERY_CHAT = BASE_URL + "/chat/query_chat"
    let API_URL_CLOSE_CHAT = BASE_URL + "/chat/close_chat"
    let API_URL_GET_CHAT_HISTORY = BASE_URL + "/chat/get_chat"
    let API_URL_SEARCH = BASE_URL + "/geo/city/d/search"
    
    let headers: HTTPHeaders = [
        "Cookie": "Authorization=\(testToken)",
        "Postman-Token": "<calculated when request is sent>"
    ]
    
    func openChat(complition: @escaping (Result<OpenChatModel, Error>) -> Void) {
        let url = API_URL_OPEN_CHAT
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers, interceptor: nil)
            .response{ resp in
                switch resp.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let data = try decoder.decode(OpenChatModel.self, from: data!)
                        complition(.success(data))
                    } catch {
                        complition(.failure(error))
                    }
                case .failure(let error):
                    complition(.failure(error))
                }
            }
    }
    
    func queryChat(question: String, complition: @escaping (Result<QueryChatModel, Error>) -> Void) {
        let url = API_URL_QUERY_CHAT
        
        let parameters: Parameters = [
            "conversation_id": UD.conversationID ?? "",
             "question": question
         ]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers, interceptor: nil)
            .response{ resp in
                switch resp.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let data = try decoder.decode(QueryChatModel.self, from: data!)
                        complition(.success(data))
                    } catch {
                        complition(.failure(error))
                    }
                case .failure(let error):
                    complition(.failure(error))
                }
            }
    }
    
    func closeChat(complition: @escaping (Result<CloseChatModel, Error>) -> Void) {
        let url = API_URL_CLOSE_CHAT
        
        let parameters: Parameters = [
            "conversation_id": UD.conversationID ?? "",
         ]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers, interceptor: nil)
            .response{ resp in
                switch resp.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let data = try decoder.decode(CloseChatModel.self, from: data!)
                        complition(.success(data))
                    } catch {
                        complition(.failure(error))
                    }
                case .failure(let error):
                    complition(.failure(error))
                }
            }
    }
    
    func getChatHistory(complition: @escaping (Result<ChatHistoryModel, Error>) -> Void) {
        let url = API_URL_GET_CHAT_HISTORY
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers, interceptor: nil)
            .response{ resp in
                switch resp.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let data = try decoder.decode(ChatHistoryModel.self, from: data!)
                        complition(.success(data))
                    } catch {
                        complition(.failure(error))
                    }
                case .failure(let error):
                    complition(.failure(error))
                }
            }
    }
}
