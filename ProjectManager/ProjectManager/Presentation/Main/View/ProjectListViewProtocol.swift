//
//  ProjectListViewProtocol.swift
//  ProjectManager
//
//  Created by Tiana on 2022/08/27.
//

protocol ProjectListViewProtocol {
    var headerView: HeaderView { get}
    var tableView: ProjectTableView { get }
}
