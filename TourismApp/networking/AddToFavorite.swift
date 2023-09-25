//
//  AddToFavorite.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 23/09/23.
//

import Foundation
import Alamofire

extension API {
    
    func addToFavorites(destionationID: String, complition: @escaping (Result<String, Error>) -> Void) {
        let url = API_URL_ADD_FAVORITES + destionationID
        
        AF.request(url, method: .put, parameters: nil, encoding: URLEncoding.default, headers: headers, interceptor: nil)
            .response{ resp in
                switch resp.result {
                case .success(_):
                    UD.favorites?.append(destionationID)
                    complition(.success("success"))
                case .failure(let error):
                    complition(.failure(error))
                }
            }
    }
    
    func removeFromFavorites(destionationID: String, complition: @escaping (Result<String, Error>) -> Void) {
        let url = API_URL_DELETE_FAVORITES + destionationID
        
        AF.request(url, method: .delete, parameters: nil, encoding: URLEncoding.default, headers: headers, interceptor: nil)
            .response{ resp in
                switch resp.result {
                case .success(_):
                    if var favorites = UD.favorites {
                        favorites = favorites.filter { element in
                            return element != destionationID
                        }
                        UD.favorites = favorites
                    }
                    complition(.success("success"))
                case .failure(let error):
                    complition(.failure(error))
                }
            }
    }
    
    func getFavorites(complition: @escaping (Result<UserData, Error>) -> Void) {
        let url = API_URL_GET_FAVORITES
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers, interceptor: nil)
            .response{ resp in
                switch resp.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let data = try decoder.decode(UserData.self, from: data!)
                        self.writeFavoritesToDatabase(favorites: data.favorites)
                        complition(.success(data))
                    } catch {
                        complition(.failure(error))
                    }
                case .failure(let error):
                    complition(.failure(error))
                }
            }
    }
    
    func writeFavoritesToDatabase(favorites: [MainDestination]?) {
        guard let favorites = favorites else { return }
        var ids = [String]()
        for favorite in favorites {
            ids.append(favorite.id)
        }
        UD.favorites = ids
    }
    
                          
}
