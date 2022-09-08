//
//  ProjectListView.swift
//  ProjectManager
//
//  Created by Tiana on 2022/08/27.
//

import UIKit

// MARK: - iPhone

final class ProjectListView: UIView, ProjectListViewProtocol {
    let headerView: HeaderView
    let tableView: ProjectTableView
    
    init(with viewModel: ProjectListViewModelProtocol) {
        self.headerView = HeaderView(viewModel: viewModel, status: viewModel.status)
        self.tableView = ProjectTableView(viewModel: viewModel)
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
