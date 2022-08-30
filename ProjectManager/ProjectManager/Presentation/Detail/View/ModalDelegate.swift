//
//  ModalDelegate.swift
//  ProjectManager
//
//  Created by Tiana, mmim on 2022/07/28.
//

import Foundation

protocol ModalViewDelegate: AnyObject {
    func changeModalViewTopConstant(to constant: Double)
}

protocol DetailViewModelDelegate: AnyObject {
    func close()
    func save()
}
