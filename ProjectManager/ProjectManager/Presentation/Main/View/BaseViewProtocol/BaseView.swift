//
//  BaseView.swift
//  ProjectManager
//
//  Created by Tiana on 2022/08/27.
//

import UIKit

// MARK: - iPhone

final class BaseView: UIView, BaseViewProtocol {
    var projects: [ProjectListViewProtocol]
    lazy var segmentedView: SegmentedView = {
        let buttons = projects.map { $0.headerView}
        let views = projects.map { $0.tableView }
        return SegmentedView(buttons: buttons, views: views)
    }()
    
    init(viewModels: [ProjectListViewModelProtocol]) {
        self.projects = viewModels.map { ProjectListView(with: $0) }
        super.init(frame: .zero)
        layout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(segmentedView)
        segmentedView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentedView.topAnchor.constraint(equalTo: topAnchor),
            segmentedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentedView.trailingAnchor.constraint(equalTo: trailingAnchor),
            segmentedView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
