//
//  BazarAPI.swift
//  TourismApp
//
//  Created by Nuriddinov Subkhiddin on 19/07/24.
//

import UIKit
import Alamofire

extension API {
    func getAllMarkets(complition: @escaping (Result<[MarketModel], Error>) -> Void) {
        let url = API_URL_GET_MARKETS
        
        let headers: HTTPHeaders = [
            "X-Token-Header": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwidXNlcm5hbWUiOiJhc2xvbiIsImlhdCI6MTUxNjIzOTAyMn0.99t27KUntzKDtpg_WRqsr7dK-4YTvR02b6WhJzS3KGQ"
            
        ]

        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers, interceptor: nil)
            .response{ resp in
                switch resp.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let data = try decoder.decode([MarketModel].self, from: data!)
                        complition(.success(data))
                        print(data)
                    } catch {
                        complition(.failure(error))
                    }
                case .failure(let error):
                    complition(.failure(error))
                }
            }
    }
}

extension API {
    
    func getProducts(for marketID: String, completion: @escaping (Result<[ProductModel], Error>) -> Void) {
        let url = "\(API_URL_GET_MARKETS)/\(marketID)/product"
        
        let headers: HTTPHeaders = [
            "X-Token-Header": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwidXNlcm5hbWUiOiJhc2xvbiIsImlhdCI6MTUxNjIzOTAyMn0.99t27KUntzKDtpg_WRqsr7dK-4YTvR02b6WhJzS3KGQ"
        ]
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .response { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        
                        guard let data = data else {
                            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                        }
                        
                        let products = try decoder.decode([ProductModel].self, from: data)
                        completion(.success(products))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}




struct MarketModel: Codable {
    let id: String?
    let address: String?
    let name: String?
    let description: String?
    let longitude: Double?
    let latitude: Double?
    let city: String?
    let phoneNumber: String?
    let overallRanking: Double?
    let imageUrl: String?
}

struct ProductModel: Codable {
    let id: String?
    let name: String?
    let price: Double?
    let category: String?
    let createdAt: String?
    let market: MarketModel?
    let description: String?
    let overallRanking: Double?
    let imageUrl: String?
}
