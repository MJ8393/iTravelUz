//
//  MainAPI.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 21/09/23.
//

import Foundation
import Alamofire

extension API {
    func getNearbyPlace(lat: Double, long: Double, complition: @escaping (Result<MainDestionationModel, Error>) -> Void) {
        let url = API_URL_GET_NEARBY
        
        let parameters: Parameters = [
            "lat": lat,
            "lng": long,
            "radius": 10000
         ]
        
        let headers = Token.getToken()

        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers, interceptor: nil)
            .response{ resp in
                switch resp.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let data = try decoder.decode(MainDestionationModel.self, from: data!)
                        complition(.success(data))
                    } catch {
                        complition(.failure(error))
                    }
                case .failure(let error):
                    complition(.failure(error))
                }
            }
    }
    
    func getMainCities(complition: @escaping (Result<CityModel, Error>) -> Void) {
        let url = API_URL_GET_CITIES
        
        let headers = Token.getToken()

        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers, interceptor: nil)
            .response{ resp in
                switch resp.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let data = try decoder.decode(CityModel.self, from: data!)
                        complition(.success(data))
                    } catch {
                        complition(.failure(error))
                    }
                case .failure(let error):
                    complition(.failure(error))
                }
            }
    }
    
    func getPopularCities(complition: @escaping (Result<PopularModel, Error>) -> Void) {
        let url = API_URL_GET_POPULAR
       
        let headers = Token.getToken()
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers, interceptor: nil)
            .response{ resp in
                switch resp.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let data = try decoder.decode(PopularModel.self, from: data!)
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
