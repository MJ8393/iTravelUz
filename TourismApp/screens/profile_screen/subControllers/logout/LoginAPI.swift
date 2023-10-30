//
//  LoginAPI.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 22/10/23.
//

import Foundation
import Alamofire

extension API {
    
    func login(username: String, password: String, complition: @escaping (Result<LoginModel, Error>) -> Void) {
        let url = API_URL_LOGIN
        
        let parameters: [String: String] = [
            "username": username,
             "password": password
         ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .response{ resp in
                switch resp.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let data = try decoder.decode(LoginModel.self, from: data!)
                        complition(.success(data))
                    } catch {
                        complition(.failure(error))
                    }
                case .failure(let error):
                    complition(.failure(error))
                }
            }
    }
    
    
    func signUp(username: String, password: String, email: String, complition: @escaping (Result<String, Error>) -> Void) {
        let url = API_URL_SIGN_UP
        
        let parameters: [String: String] = [
            "username": username,
            "password": password,
            "email": email
         ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .response{ resp in
                switch resp.result {
                case .success(_):
                    complition(.success("Success"))
                case .failure(let error):
                    print("xxx", error.localizedDescription)
                    complition(.failure(error))
                }
            }
    }
    
    func deleteUser(complition: @escaping (Result<String, Error>) -> Void) {
        let url = API_URL_DELETE_USER
        
        let headers = Token.getToken()

        AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: headers)
            .response{ resp in
                switch resp.result {
                case .success(_):
                    complition(.success("Success"))
                case .failure(let error):
                    complition(.failure(error))
                }
            }
    }
    
    
}

struct LoginModel: Codable {
    let Authorization: String
    let expiration_time: String
}

