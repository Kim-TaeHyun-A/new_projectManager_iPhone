//
//  NetworkError.swift
//  ProjectManager
//
//  Created by Tiana on 2022/08/30.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidStatusCode(statusCode: Int)
    case emptyData
    case responseError(error: Error)
    case decodeError
    case encodeError
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
        case .decodeError:
            return "decodeError"
        case .encodeError:
            return "encodeError"
        }
    }
}

extension NetworkError: LogProtocol {
    typealias ErrorType = Self
}
