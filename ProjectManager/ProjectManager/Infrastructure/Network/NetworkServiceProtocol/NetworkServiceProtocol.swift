//
//  NetworkServiceProtocol.swift
//  ProjectManager
//
//  Created by Tiana on 2022/09/12.
//

import Foundation

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
