//
//  File.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 13/08/23.
//

import Foundation
import Alamofire

let BASE_URL = "http://127.0.0.1:8080"

class API {
    static let shared = API()
    
    let API_URL_OPEN_CHAT = BASE_URL + "/open_chat"
    
    func openChat(complition: @escaping (Result<OpenChatModel, Error>) -> Void) {
        let url = API_URL_OPEN_CHAT
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil)
            .response{ resp in
                print(resp.result)
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
    
    
}
