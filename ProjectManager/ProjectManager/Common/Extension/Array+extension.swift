//
//  Array+extension.swift
//  ProjectManager
//
//  Created by Tiana on 2022/08/26.
//

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
