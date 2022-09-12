//
//  NetworkService.swift
//  ProjectManager
//
//  Created by Tiana on 2022/08/30.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {
    weak var delegate: ToastDelegate?
    
    func request(with url: URL?, method: RequestMethod, completion: @escaping (Result<Data, NetworkError>) -> Void) -> CancelProtocol? {
        guard let url = url,
              let request = method.setUpRequest(url: url) else {
            completion(.failure(.invalidURL))
            showFailure()
            return nil
        }
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, urlResponse, error in
            if let error = error {
                completion(.failure(.responseError(error: error)))
                self?.showFailure()
            }
            
            if let response = urlResponse as? HTTPURLResponse,
               !(200...299).contains(response.statusCode) {
                completion(.failure(.invalidStatusCode(statusCode: response.statusCode)))
                self?.showFailure()
            }
            
            guard let data = data else {
                completion(.failure(.emptyData))
                self?.showFailure()
                return
            }
            
            completion(.success(data))
            self?.showSuccess()
        }
        
        task.resume()
        return task
    }
}

extension URLSessionDataTask: CancelProtocol {
    func cancelTask() {
        cancel()
    }
}
