//
//  LogProtocol.swift
//  ProjectManager
//
//  Created by Tiana on 2022/08/30.
//

import Foundation

protocol LogProtocol {
    associatedtype ErrorType: LocalizedError
}

extension LogProtocol {
    func printIfDebug() {
        if let error = self as? ErrorType,
           let errorDescription = error.errorDescription {
            #if DEBUG
            print(errorDescription)
            #endif
        }
    }
}
