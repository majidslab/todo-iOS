//
//  NetworkManager.swift
//  todo-online
//
//  Created by Majid Jamali on 1/22/25.
//

import SwiftUI

final class NetworkManager: NSObject, ObservableObject {
    
    enum Method: String {
        case post = "POST"
        case get = "GET"
        case patch = "PATCH"
        case delete = "DELETE"
    }
    
    func request<Element:Codable>(_ e: Element.Type, url: URL?, method: Method, requestBody: Codable?, isPublicBearer: Bool, userAuthenticationBearer: String?, resulting: @escaping ((Element?, ErrorResult?) -> Void)) {
        
        guard let url else {
            return resulting(nil, nil)
        }
        
        print(url)
        
        var request = URLRequest(url: url)
        if isPublicBearer {
            request.setValue( "Bearer \(URL.publicBearerToken)", forHTTPHeaderField: "Authorization")
        } else {
            if let userAuthenticationBearer {
                request.setValue( "Bearer " + userAuthenticationBearer, forHTTPHeaderField: "Authorization")
            }
        }
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if let requestBody {
            let encoder = JSONEncoder()
            guard let body = try? encoder.encode(requestBody) else {
                return resulting(nil, nil)
            }
            request.httpBody = body
        }
        
        URLSession.shared.dataTask(with: request) { data, resp, error in
            let decoder = JSONDecoder()
            if let error {
                print("new request failed with error: " + error.localizedDescription)
                return resulting(nil, ErrorResult(message: error.localizedDescription,error: "", statusCode: 0))
            }
            if let data {
                do {
                    let result = try decoder.decode(Element.self, from: data)
                    print("new request succeeded.")
                    return resulting(result, nil)
                } catch {
                    let error = try? decoder.decode(ErrorResult.self, from: data)
                    print("new request failed with error: " + (error?.message ?? "nil"))
                    return resulting(nil, error)
                }
            } else {
                print("new request failed with error: " + "nil")
                return resulting(nil, nil)
            }
        }.resume()
    }
    
    func groupResultingRequest<Element:Codable>(_ e: [Element].Type, url: URL?, method: Method, requestBody: Codable?, isPublicBearer: Bool, userAuthenticationBearer: String?, resulting: @escaping (([Element]?, ErrorResult?) -> Void)) {
        
        guard let url else {
            return resulting(nil, nil)
        }
        
        var request = URLRequest(url: url)
        if isPublicBearer {
            request.setValue( "Bearer \(URL.publicBearerToken)", forHTTPHeaderField: "Authorization")
        } else {
            if let userAuthenticationBearer {
                request.setValue( "Bearer " + userAuthenticationBearer, forHTTPHeaderField: "Authorization")
            }
        }
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if let requestBody {
            let encoder = JSONEncoder()
            guard let body = try? encoder.encode(requestBody) else {
                return resulting(nil, nil)
            }
            request.httpBody = body
        }
        
        URLSession.shared.dataTask(with: request) { data, resp, error in
            let decoder = JSONDecoder()
            if let error {
                print("new request failed with error: " + error.localizedDescription)
                return resulting(nil, ErrorResult(message: error.localizedDescription,error: "", statusCode: 0))
            }
            if let data {
                do {
                    let result = try decoder.decode([Element].self, from: data)
                    print("new request succeeded.")
                    return resulting(result, nil)
                } catch {
                    let error = try? decoder.decode(ErrorResult.self, from: data)
                    print("new request failed with error: " + (error?.message ?? "nil"))
                    return resulting(nil, error)
                }
            } else {
                print("new request failed with error: " + "nil")
                return resulting(nil, nil)
            }
        }.resume()
    }
}
