//
//  RestaurantAPI.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 04/12/23.
//

import Foundation
import Alamofire

extension API {
    func getAllRestaurant(complition: @escaping (Result<[RestaurantModel], Error>) -> Void) {
        let url = API_URL_GET_RESTRAURANT
        
        let headers = Token.getToken()

        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers, interceptor: nil)
            .response{ resp in
                switch resp.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let data = try decoder.decode([RestaurantModel].self, from: data!)
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


struct RestaurantModel: Codable {
    let _id: String
    let name: String
    let location: MainLocation?
    let city: String?
    let photos: [String]?
}
