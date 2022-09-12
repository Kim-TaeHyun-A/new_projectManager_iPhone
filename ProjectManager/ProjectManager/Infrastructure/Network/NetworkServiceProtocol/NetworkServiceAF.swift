//
//  NetworkServiceAF.swift
//  ProjectManager
//
//  Created by 김태현 on 2022/09/12.
//

import Alamofire

final class NetworkServiceAF: NetworkServiceProtocol {
    weak var delegate: ToastDelegate?
    
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

extension DataRequest: CancelProtocol {
    func cancelTask() {
        cancel()
    }
}
