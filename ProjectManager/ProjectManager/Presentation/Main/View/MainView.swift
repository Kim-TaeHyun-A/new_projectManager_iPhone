//
//  MainView.swift
//  ProjectManager
//
//  Created by Tiana, mmim on 2022/07/04.
//

import RxCocoa

protocol MainViewProtocol: UIView {
    var projects: [ProjectListViewProtocol] { get set }
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
