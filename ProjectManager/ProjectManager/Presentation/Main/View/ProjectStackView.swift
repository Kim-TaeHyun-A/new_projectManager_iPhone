//
//  ProjectStackView.swift
//  ProjectManager
//
//  Created by Tiana, mmim on 2022/07/07.
//

import UIKit

protocol ProjectListViewProtocol {
    var headerView: HeaderView { get}
    var tableView: ProjectTableView { get }
}

final class ProjectStackView: UIStackView, ProjectListViewProtocol {
    let headerView: HeaderView
    let tableView: ProjectTableView
    
    init(with viewModel: ProjectListViewModelProtocol) {
        self.headerView = HeaderView(viewModel: viewModel, status: viewModel.status)
        self.tableView = ProjectTableView(viewModel: viewModel)
        super.init(frame: .zero)
        layout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        axis = .vertical
        addArrangedSubview(headerView)
        addArrangedSubview(tableView)
    }
}
