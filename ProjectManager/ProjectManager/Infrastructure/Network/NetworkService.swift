//
//  NetworkService.swift
//  ProjectManager
//
//  Created by Tiana on 2022/08/30.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidStatusCode(statusCode: Int?)
    case emptyData
    case responseError(error: Error)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "invalidURL"
        case .invalidStatusCode(let statusCode):
            return "statusCode: \(String(describing: statusCode))"
        case .emptyData:
            return "emptyData"
        case .responseError(let error):
            return "respondError: \(String(describing: error))"
        }
    }
}

final class NetworkService {
    static let shared = NetworkService()
    
    private init() { }
    
    func setUpURLRequest(with url: URL?, data: Data? = nil) -> URLRequest? {
        guard let url = url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = data
        return request
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
