//
//  HotelAPI.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 04/12/23.
//

import Foundation
import Alamofire

extension API {
    func getAllHotels(complition: @escaping (Result<[HotelModel], Error>) -> Void) {
        let url = API_URL_GET_HOTELS
        
        let headers = Token.getToken()

        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers, interceptor: nil)
            .response{ resp in
                switch resp.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let data = try decoder.decode([HotelModel].self, from: data!)
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


struct HotelModel: Codable {
    let _id: String
    let name: String?
    let description: String
    let location: MainLocation?
    let star: Int?
    let city: String?
    let photos: [String]?
    let mostPopularFacilities: [String]?
    let phone: String?
    let website: String?
    let email: String?
}
