//
//  NetworkService.swift
//  ProjectManager
//
//  Created by Tiana on 2022/08/30.
//

import Foundation
import Alamofire

protocol NetworkServiceProtocol {
    var delegate: ToastDelegate? { get }
    
    @discardableResult
    func request(with url: URL?, method: RequestMethod, completion: @escaping (Result<Data, NetworkError>) -> Void) -> CancelProtocol?
}

extension NetworkServiceProtocol {
    func showFailure() {
        delegate?.show(message: "네트워크 오류")
    }
    
    func showSuccess() {
        delegate?.show(message: "데이터 로드 성공")
    }
}

protocol CancelProtocol {
    func cancelTask()
}

extension URLSessionDataTask: CancelProtocol {
    func cancelTask() {
        cancel()
    }
}
extension DataRequest: CancelProtocol {
    func cancelTask() {
        cancel()
    }
}

final class NetworkServiceAF: NetworkServiceProtocol {
    var delegate: ToastDelegate?
    
    func request(with url: URL?, method: RequestMethod, completion: @escaping (Result<Data, NetworkError>) -> Void) -> CancelProtocol? {
        guard let url = url else {
            completion(.failure(.invalidURL))
            showFailure()
            return nil
        }
        let request: DataRequest
        switch method {
        case .get:
            request = AF.request(url, method: .get)
        case .put(let data):
            request = AF.request(url, method: .put,
                                 parameters: data,
                                 encoding: JSONEncoding.default)
        }
        request
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { [weak self] response in
                switch response.result {
                case .success:
                    guard let data = response.data else {
                        completion(.failure(.emptyData))
                        self?.showFailure()
                        return
                    }
                    completion(.success(data))
                    self?.showSuccess()
                case let .failure(error):
                    completion(.failure(.responseError(error: error)))
                    self?.showFailure()
                }
            }
        return request
    }
}

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
