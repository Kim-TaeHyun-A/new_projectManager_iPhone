//
//  ModalConstant.swift
//  ProjectManager
//
//  Created by Tiana, mmim on 2022/07/28.
//

import UIKit

enum ModalConstant {
    static let modalFrameWidth: Double = 500
    static let modalFrameHeight: Double = 600
    static let minTopConstant: Double = {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return 30
        default:
            return 0
        }
    }()
}
