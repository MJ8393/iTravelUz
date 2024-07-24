//
//  File.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 13/08/23.
//

import Foundation
import Alamofire

let BASE_URL = "http://guide-me.uz"
let BASE_URL_RAHMATULLO = "http://164.90.235.157"
let testToken = UD.token ?? ""
//let testToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MDA3MzAyODYsInVzZXIiOiJhc2xvbiJ9.IKB0rjKM5_5Y-ps6_aM6Tcau5aJpevkB2DIDS_wuo7w"

class API {
    static let shared = API()
    
    let API_URL_OPEN_CHAT = BASE_URL + "/chat/open_chat"
    let API_URL_QUERY_CHAT = BASE_URL + "/chat/query_chat"
    let API_URL_CLOSE_CHAT = BASE_URL + "/chat/close_chat"
    let API_URL_GET_CHAT_HISTORY = BASE_URL + "/chat/get_chat"
    let API_URL_SEARCH = BASE_URL + "/geo/city/d/search"
    let API_URL_SEARCH_CITY = BASE_URL + "/search?name="
    
    // MAIN
    let API_URL_GET_NEARBY = BASE_URL + "/geo/city/d/nearby_destinations"
    let API_URL_GET_CITIES = BASE_URL + "/geo/all_cities"
    let API_URL_GET_POPULAR = BASE_URL + "/geo/city/d/main/popular_destinations"
    
    
    // Favorites
    let API_URL_ADD_FAVORITES = BASE_URL + "/accounts/add_to_favorites/"
    let API_URL_DELETE_FAVORITES = BASE_URL + "/accounts/remove_from_favorites/"
    let API_URL_GET_FAVORITES = BASE_URL + "/accounts"
    
    // Login
    let API_URL_LOGIN = BASE_URL + "/accounts/login"
    let API_URL_SIGN_UP = BASE_URL + "/accounts/signup"
    let API_URL_DELETE_USER = BASE_URL + "/accounts"

    // Rate Destionation
    let API_URL_RATE = BASE_URL + "/accounts/rate_destination/"
    let API_URL_COMMENT = BASE_URL + "/geo/city/destination/"
    
    // Hotel
    let API_URL_GET_HOTELS = BASE_URL + "/hotels"
    let API_URL_GET_RESTRAURANT = BASE_URL + "/restaurants"
    
    // Bazar
    let API_URL_GET_MARKETS = BASE_URL_RAHMATULLO + ":8084/api/market"
    
    // Trip Planner
    let API_URL_PLAN_TRIP = BASE_URL + "/plans/make_plan_for_me"

    
    func openChat(language: String, complition: @escaping (Result<OpenChatModel, Error>) -> Void) {
        let url = API_URL_OPEN_CHAT
        
        let parameters: Parameters = [
            "language": language
         ]
        
        let headers = Token.getToken()
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers, interceptor: nil)
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
    
    func queryChat(question: String, language: String, complition: @escaping (Result<QueryChatModel, Error>) -> Void) {
        let url = API_URL_QUERY_CHAT
        
        let parameters: Parameters = [
            "conversation_id": UD.conversationID ?? "",
             "question": question,
            "language": language
         ]
        let headers = Token.getToken()

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
    
    func closeChat(language: String, complition: @escaping (Result<CloseChatModel, Error>) -> Void) {
        let url = API_URL_CLOSE_CHAT
        
        let parameters: Parameters = [
            "conversation_id": UD.conversationID ?? "",
            "language": language
         ]
        
        let headers = Token.getToken()
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
        let headers = Token.getToken()
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

class Token {
    static func getToken() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "Cookie": "Authorization=\(UD.token ?? "")",
            "Postman-Token": "<calculated when request is sent>"
        ]
        return headers
    }
}
