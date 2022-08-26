//
//  MainViewProtocol.swift
//  ProjectManager
//
//  Created by Tiana on 2022/08/27.
//

import UIKit

protocol MainViewProtocol: UIView {
    var projects: [ProjectListViewProtocol] { get set }
}
