//
//  ListView.swift
//  ProjectManager
//
//  Created by Tiana on 2022/08/27.
//

final class ListView: ProjectListViewProtocol {
    let headerView: HeaderView
    let tableView: ProjectTableView
    
    init(with viewModel: ProjectListViewModelProtocol) {
        self.headerView = HeaderView(viewModel: viewModel, status: viewModel.status)
        self.tableView = ProjectTableView(viewModel: viewModel)
    }
}
