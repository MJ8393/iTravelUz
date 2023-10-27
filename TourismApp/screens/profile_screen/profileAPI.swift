//
//  profileAPI.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 27/09/23.
//

import Foundation
import Alamofire

extension API {
    
    func getUserData(complition: @escaping (Result<ProfileInfo, Error>) -> Void) {
        let url = API_URL_GET_FAVORITES
        let headers = Token.getToken()
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers, interceptor: nil)
            .response{ resp in
                switch resp.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let data = try decoder.decode(ProfileInfo.self, from: data!)
                        complition(.success(data))
                    } catch {
                        complition(.failure(error))
                    }
                case .failure(let error):
                    complition(.failure(error))
                }
            }
    }
    
    
    func addCommend(comment: String, destination_ID: String, complition: @escaping (Result<String, Error>) -> Void) {
        let url = API_URL_COMMENT + "\(destination_ID)/add_comment"
        
        let parameters: [String: String] = [
            "comment_body": "\(comment)",
         ]
        
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default)
            .response{ resp in
                switch resp.result {
                case .success(let _):
                    complition(.success("success"))
                case .failure(let error):
                    complition(.failure(error))
                }
            }
    }
    
    func rateDestination(score: Int, destination_ID: String, complition: @escaping (Result<String, Error>) -> Void) {
        let url = API_URL_RATE + "\(destination_ID)"
        
        let parameters: [String: String] = [
            "score": "\(score)",
             "rating_message": "Message"
         ]
        
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default)
            .response{ resp in
                switch resp.result {
                case .success(let _):
                    complition(.success("success"))
                case .failure(let error):
                    complition(.failure(error))
                }
            }
    }
    
    
}

struct ProfileInfo: Codable {
    let email: String?
//    let rated: [RatedDestination]?
    let username: String?
    let comments: [MainDestination]?
    let user_id: String?
}

struct RatedDestination: Codable {
    let id: String
    let name: String
    let city_name: String?
    let gallery: [Gallery]?
}
