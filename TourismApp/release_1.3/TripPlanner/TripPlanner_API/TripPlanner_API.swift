//
//  TripPlanner_API.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 15/01/24.
//

import UIKit
import Alamofire

extension API {
    func planTrip(model: TripPlannerModel, completion: @escaping (Result<PlanTripModel, Error>) -> Void) {
        let url = API_URL_PLAN_TRIP
        
        let parameters: Parameters = [
            "CityName": model.CityName,
            "StartDate": model.StartDate,
            "daysLength": model.daysLength,
            "budget": model.budget,
            "interests": model.interests ?? [""]
        ]
        
        let headers = Token.getToken()
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .response { resp in
                switch resp.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let data = try decoder.decode(PlanTripModel.self, from: data!)
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

