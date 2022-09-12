//
//  RequestMethod.swift
//  ProjectManager
//
//  Created by Tiana on 2022/08/30.
//

import Foundation

enum RequestMethod {
    case get
    case put(data: [String: Encodable])
}

extension RequestMethod {
    // AF에서는 사용X
    func setUpRequest(url: URL) -> URLRequest? {
        var request = URLRequest(url: url)
        switch self {
        case .get:
            request.httpMethod = "GET"
        case .put(let data):
            request.httpMethod = "PUT"
            guard let data = data as? [String: [String: String]],
                  let data = try? JSONEncoder().encode(data) else {
                NetworkError.encodeError.printIfDebug()
                return nil
            }
            request.httpBody = data
        }
        return request
    }
}
