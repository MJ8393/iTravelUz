//
//  search_api.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 21/09/23.
//

import Foundation
import Alamofire

extension API {
    func searchDestination(name: String, completion: @escaping (Result<SearchModel, Error>) -> Void) {
        let url = API_URL_SEARCH
        
        let parameters: Parameters = [
            "name": name
        ]
        
        let headers = Token.getToken()

        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers, interceptor: nil)
            .response{ resp in
                switch resp.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let data = try decoder.decode(SearchModel.self, from: data!)
                        completion(.success(data))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
