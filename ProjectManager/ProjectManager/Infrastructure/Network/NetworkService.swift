//
//  NetworkService.swift
//  ProjectManager
//
//  Created by Tiana on 2022/08/30.
//

import Foundation

protocol NetworkServiceProtocol {
    @discardableResult
    func request(with request: URLRequest?, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask?
}

final class NetworkService: NetworkServiceProtocol {
    var delegate: ToastDelegte?
    
    init() {
        RequestMethod.url = EntryPoint.database(child: "user").url
    }
    
    func request(with request: URLRequest?, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        guard let request = request else {
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

extension NetworkService {
    private func showFailure() {
        delegate?.show(message: "네트워크 오류")
    }
    
    private func showSuccess() {
        delegate?.show(message: "데이터 로드 성공")
    }
}
