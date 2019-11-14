//
//  Network.swift
//  Aaraa
//
//  Created by Mina Malak on 6/17/19.
//  Copyright © 2019 Mina Malak. All rights reserved.
//  Network class using URLSessionRequest

import UIKit

enum HTTPMethod: String{
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

enum ServiceError: Error {
    case noInternetConnection
    case unauthorizedUser
    case custom(String)
    case serverError
    case manyRequests
    case other
}

extension ServiceError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return "No Internet connection"
        case .unauthorizedUser:
            return "Unauthorized user"
        case .other:
            return "Something went wrong"
        case .serverError:
            return "Internal Server Error"
        case .manyRequests:
            return "Many Requests make error"
        case .custom(let message):
            return message
        }
    }
}

class Network{
    
    static let shared = Network()
    
    func makeHttpRequest<T: Decodable>(model: T,method: HTTPMethod, APIName: String, parameters: [String: Any]?, completion: @escaping (Result<T, ServiceError>)->()) {
        
        var request : URLRequest!
        if let parameters = parameters {
            switch method{
            case .post, .delete:
                request = URLRequest(url: URL(string: Constants.baseUrl + APIName)!)
                request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
            case .get:
                //                print(parameters)
                let queryParameters = parameters.queryString
                request = URLRequest(url: URL(string: Constants.baseUrl + APIName + "?"+queryParameters)!)
            }
        }
        else {
            
            // replace spaces
            let apiName = APIName.replacingOccurrences(of: " ", with: "%20")
            if let url = URL(string: Constants.baseUrl + apiName){
                request = URLRequest(url: url)
            }
            else {
                let safeUrl = APIName.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
                if let url = URL(string: Constants.baseUrl + safeUrl) {
                    request = URLRequest(url: url)
                }
            }
        }
        
        request.httpMethod = method.rawValue
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            //                        let str = String(bytes: data!, encoding: .utf8)
            //                        print(str)
            
            if let response = response as? HTTPURLResponse{
                if response.statusCode == 200{
                    if let data = data {
                        do {
                            let model = try JSONDecoder().decode(T.self, from: data)
                            completion(.success(model))
                        }
                        catch {
                            print(error)
                            completion(.failure(ServiceError.custom(error.localizedDescription)))
                        }
                    }
                }else if (response.statusCode == 429){
                    completion(.failure(ServiceError.manyRequests))
                }else if (response.statusCode == 401){
                    completion(.failure(ServiceError.unauthorizedUser))
                }else if (response.statusCode == 500){
                    completion(.failure(ServiceError.serverError))
                }
                else{
                    if let data = data{
                        do {
                            if let jsonResponce = try  JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]{
                                
                                if let errorMessage = jsonResponce["error"] as? String{
                                    completion(.failure(ServiceError.custom(errorMessage)))
                                }
                                else {
                                    
                                    completion(.failure(ServiceError.custom("errpr please try again later")))
                                }
                            }
                        }
                        catch {
                            completion(.failure(ServiceError.custom(error.localizedDescription)))
                        }
                    }
                }
            }
            else {
                completion(.failure(ServiceError.noInternetConnection))
            }
        }.resume()
    }
}
