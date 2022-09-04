//
//  ProjectListViewProtocol.swift
//  ProjectManager
//
//  Created by Tiana on 2022/08/27.
//

import UIKit

protocol ProjectListViewProtocol: UIView {
    var headerView: HeaderView { get}
    var tableView: ProjectTableView { get }
}
