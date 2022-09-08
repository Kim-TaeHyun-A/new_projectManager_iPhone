//
//  BaseViewProtocol.swift
//  ProjectManager
//
//  Created by Tiana on 2022/08/27.
//

import UIKit

protocol BaseViewProtocol: UIView {
    var projects: [ProjectListViewProtocol] { get set }
}
