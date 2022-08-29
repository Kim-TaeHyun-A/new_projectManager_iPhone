//
//  RequestMethod.swift
//  ProjectManager
//
//  Created by Tiana on 2022/08/30.
//

import Foundation

enum RequestMethod {
    case get
    case put(data: Data?)
    
    static var url: URL?
}

extension RequestMethod {
    var urlRequest: URLRequest? {
        guard let url = RequestMethod.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        switch self {
        case .get:
            request.httpMethod = "GET"
        case .put(let data):
            request.httpMethod = "PUT"
            request.httpBody = data
        }
        return request
    }
}
