//
//  NetworkService.swift
//  ProjectManager
//
//  Created by Tiana on 2022/08/30.
//

import Foundation

protocol NetworkServiceProtocol {
    func request(with request: URLRequest?, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask?
}

final class NetworkService: NetworkServiceProtocol {
    init() {
        RequestMethod.url = EntryPoint.database(child: "user").url
    }
    
    func request(with request: URLRequest?, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        guard let request = request else {
            completion(.failure(.invalidURL))
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
            if let error = error {
                return completion(.failure(.responseError(error: error)))
            }
            
            if let response = urlResponse as? HTTPURLResponse,
               !(200...299).contains(response.statusCode) {
                completion(.failure(.invalidStatusCode(statusCode: response.statusCode)))
                return
            }
            
            guard let data = data else {
                return completion(.failure(.emptyData))
            }
            
            completion(.success(data))
        }
        
        task.resume()
        return task
    }
}
