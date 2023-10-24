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
    
}

struct ProfileInfo: Codable {
    let email: String
    let rated: [RatedDestination]
    let username: String?
}

struct RatedDestination: Codable {
    let id: String
    let name: String
    let city_name: String?
    let gallery: [Gallery]?
}
