//
//  MainView.swift
//  ProjectManager
//
//  Created by Tiana, mmim on 2022/07/04.
//

import RxCocoa

protocol ProjectListViewProtocol {
    var headerView: HeaderView { get}
    var tableView: ProjectTableView { get }
}

protocol MainViewProtocol: UIView {
    var projects: [ProjectListViewProtocol] { get set }
}

final class BaseStackView: UIStackView, MainViewProtocol {
    private var viewModels: [ProjectListViewModelProtocol]
    lazy var projects: [ProjectListViewProtocol] = {
        return viewModels.map {
            ProjectStackView(with: $0)
        }
    }()
    
    init(viewModels: [ProjectListViewModelProtocol]) {
        self.viewModels = viewModels
        super.init(frame: .zero)
        
        setUpAttribute()
        layout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpAttribute() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .horizontal
        distribution = .fillEqually
        spacing = 10
        backgroundColor = .systemGray4
    }
    
    private func layout() {
        projects.forEach {
            guard let view = $0 as? UIView else {
                return
            }
            addArrangedSubview(view)
        }
    }
}

final class ListView: ProjectListViewProtocol {
    let headerView: HeaderView
    let tableView: ProjectTableView
    
    init(with viewModel: ProjectListViewModelProtocol) {
        self.headerView = HeaderView(viewModel: viewModel, status: viewModel.status)
        self.tableView = ProjectTableView(viewModel: viewModel)
    }
}

final class BaseView: UIView, MainViewProtocol {
    var projects: [ProjectListViewProtocol]
    lazy var segmentedView: SegmentedView = {
        let buttons = projects.map { $0.headerView}
        let views = projects.map { $0.tableView }
        return SegmentedView(buttons: buttons, views: views)
    }()
    
    init(viewModels: [ProjectListViewModelProtocol]) {
        self.projects = viewModels.map { ListView(with: $0) }
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

final class MainView: UIView {
    let baseView: MainViewProtocol
    
    init(projectListViewModels: [ProjectListViewModelProtocol]) {
        let viewModels: [ProjectListViewModelProtocol] = ProjectStatus.allCases
            .compactMap { status in
                guard let viewModel = projectListViewModels.first(where: { $0.status == status }) else {
                    return nil
                }
                
                return viewModel
            }
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            baseView = BaseStackView(viewModels: viewModels)
        default: // .phone
            baseView = BaseView(viewModels: viewModels)
        }
        
        super.init(frame: .zero)
        
        setUpBackgroundColor()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpBackgroundColor() {
        backgroundColor = .systemBackground
    }
    
    private func setUpLayout() {
        addSubview(baseView)
        baseView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            baseView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            baseView.bottomAnchor.constraint(equalTo: bottomAnchor),
            baseView.leadingAnchor.constraint(equalTo: leadingAnchor),
            baseView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
