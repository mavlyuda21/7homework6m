//
//  APIManager.swift
//  7homework6m
//
//  Created by mavluda on 7/7/23.
//

import Foundation

protocol APIManagerProtocol{
    func fetchIPAddress(completion: @escaping (Result<String, Error>) -> Void)
}

class APIManager: APIManagerProtocol {
    
    static let shared = APIManager()
    private let session: URLSession
    
    private init() {
        let configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration)
    }
    
    func fetchIPAddress(completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://api.ipify.org?format=json") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.invalidData))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                guard let ipAddress = json?["ip"] as? String else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }
                
                completion(.success(ipAddress))
            } catch {
                completion(.failure(NetworkError.serializationError))
            }
        }
        
        task.resume()
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidData
    case invalidResponse
    case serializationError
}
