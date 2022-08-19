//
//  ProjectListView.swift
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

final class ProjectListView: UIStackView {
    private var viewModel: ProjectListViewModelProtocol?
    private let disposeBag = DisposeBag()
    let headerView: HeaderView
    let tableView = UITableView()
    weak var delegate: ProjectListViewDelegate?
    
    init(with viewModel: ProjectListViewModelProtocol) {
        self.viewModel = viewModel
        self.headerView = HeaderView(status: viewModel.status)
        super.init(frame: .zero)
        
        layout()
        setUpTableView()
        bind()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        axis = .vertical
        addArrangedSubview(headerView)
        addArrangedSubview(tableView)
    }
    
    private func setUpTableView() {
        tableView.register(ProjectCell.self, forCellReuseIdentifier: "\(ProjectCell.self)")
        tableView.backgroundColor = .systemGray6
        tableView.tableFooterView = UIView()
    }
    
    private func bind() {
        bindTableView()
        bindCountLabel()
    }
    
    private func bindTableView() {
        bindItemSelected()
        bindModelDeleted()
        bindCell()
        bindGesture()
    }
    
    private func bindItemSelected() {
        tableView.rx
            .itemSelected
            .bind { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindModelDeleted() {
        tableView.rx
            .modelDeleted(ProjectEntity.self)
            .asDriver()
            .drive { [weak self] project in
                self?.viewModel?.didDeleteCell(content: project)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindCell() {
        viewModel?.statusProject
            .drive(tableView.rx.items(
                cellIdentifier: "\(ProjectCell.self)",
                cellType: ProjectCell.self)
            ) { _, item, cell in
                cell.compose(content: item)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindGesture() {
        let gesture = tableView.rx
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
                self?.delegate?.didTap(cell: cell)
            }
            .disposed(by: disposeBag)
        
        gesture.filter { $0.state == .began }
            .compactMap { [weak self] in
                self?.findCell(by: $0)
            }
            .bind { [weak self] in
                self?.delegate?.didLongPress(cell: $0)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindCountLabel() {
        viewModel?.statusProject
            .map { "\($0.count)" }
            .drive { [weak self] count in
                self?.headerView.composeCountLabel(with: count)
            }
            .disposed(by: disposeBag)
    }
    
    private func findCell(by event: RxGestureRecognizer) -> ProjectCell? {
        let point = event.location(in: tableView)
        
        guard let indexPath = tableView.indexPathForRow(at: point),
              let cell = tableView.cellForRow(at: indexPath) as? ProjectCell else {
            return nil
        }
        
        return cell
    }
}
