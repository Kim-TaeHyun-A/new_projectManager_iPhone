//
//  EntryPoint.swift
//  ProjectManager
//
//  Created by Tiana on 2022/08/30.
//

import Foundation

enum EntryPoint {
    case database(child: String)
    
    static let hostURL = "https://new-projectmanager-default-rtdb.firebaseio.com/"
    
    var url: URL? {
        switch self {
        case .database(let child):
            return URL(string: EntryPoint.hostURL + "\(child).json")
        }
    }
}
