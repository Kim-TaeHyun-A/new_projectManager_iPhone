//
//  ProjectStackView.swift
//  ProjectManager
//
//  Created by Tiana, mmim on 2022/07/07.
//

import UIKit
import RxCocoa
import RxSwift
import RxGesture

protocol ProjectListViewDelegate: AnyObject {
    func didTap(cell: ProjectCell)
    func didLongPress(cell: ProjectCell)
}

final class ProjectTableView: UITableView {
    private var viewModel: ProjectListViewModelProtocol?
    private let disposeBag = DisposeBag()
    weak var projectDelegate: ProjectListViewDelegate?
    
    init(viewModel: ProjectListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero, style: .plain)
        setUpTableView()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpTableView() {
        register(ProjectCell.self, forCellReuseIdentifier: "\(ProjectCell.self)")
        backgroundColor = .systemGray6
        tableFooterView = UIView()
    }
    
    private func bind() {
        bindItemSelected()
        bindModelDeleted()
        bindCell()
        bindGesture()
    }
    
    private func bindItemSelected() {
        rx.itemSelected
            .bind { [weak self] indexPath in
                self?.deselectRow(at: indexPath, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindModelDeleted() {
        rx.modelDeleted(ProjectEntity.self)
            .asDriver()
            .drive { [weak self] project in
                self?.viewModel?.didDeleteCell(content: project)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindCell() {
        viewModel?.statusProject
            .drive(rx.items(
                cellIdentifier: "\(ProjectCell.self)",
                cellType: ProjectCell.self)
            ) { _, item, cell in
                cell.compose(content: item)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindGesture() {
        let gesture = rx
            .anyGesture(
                (.tap(), when: .recognized),
                (.longPress(), when: .began)
            )
            .asObservable()
        
        gesture.filter { $0.state == .recognized }
            .bind { [weak self] in
                guard let cell = self?.findCell(by: $0) else {
                    return
                }
                self?.projectDelegate?.didTap(cell: cell)
            }
            .disposed(by: disposeBag)
        
        gesture.filter { $0.state == .began }
            .compactMap { [weak self] in
                self?.findCell(by: $0)
            }
            .bind { [weak self] in
                self?.projectDelegate?.didLongPress(cell: $0)
            }
            .disposed(by: disposeBag)
    }
    
    private func findCell(by event: RxGestureRecognizer) -> ProjectCell? {
        let point = event.location(in: self)
        
        guard let indexPath = indexPathForRow(at: point),
              let cell = cellForRow(at: indexPath) as? ProjectCell else {
            return nil
        }
        
        return cell
    }
}

final class ProjectStackView: UIStackView {
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
