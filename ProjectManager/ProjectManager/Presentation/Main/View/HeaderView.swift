//
//  HeaderView.swift
//  ProjectManager
//
//  Created by Tiana on 2022/08/20.
//

import UIKit
import RxSwift

private enum Constant {
    static let titleFont: UIFont = {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return .preferredFont(forTextStyle: .largeTitle)
        default:
            return .preferredFont(forTextStyle: .body)
        }
    }()
    
    static let labelRadius: CGFloat = {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return 20
        default:
            return 10
        }
    }()
}

final class HeaderView: UIView {
    private var viewModel: ProjectListViewModelProtocol?
    private let disposeBag = DisposeBag()
    
    let listTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.titleFont
        return label
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = Constant.labelRadius
        label.textColor = .white
        label.text = "0"
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .black
        return label
    }()
    
    let baseStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        return stackView
    }()
    
    init(viewModel: ProjectListViewModelProtocol, status: ProjectStatus) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setUpIsInteractive()
        setUpLayout()
        bind()
        setUpTitle(title: status.string)
        setUpBackground()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpIsInteractive() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            isUserInteractionEnabled = true
        }
    }
    
    private func setUpLayout() {
        addSubview(baseStackView)
        baseStackView.addArrangedSubview(listTitleLabel)
        baseStackView.addArrangedSubview(countLabel)
        
        NSLayoutConstraint.activate([
            baseStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            baseStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            countLabel.widthAnchor.constraint(equalTo: countLabel.heightAnchor)
        ])
    }
    
    private func bind() {
        viewModel?.statusProject
            .map { "\($0.count)" }
            .drive { [weak self] count in
                self?.composeCountLabel(with: count)
            }
            .disposed(by: disposeBag)
    }
    
    private func setUpTitle(title: String) {
        listTitleLabel.text = title
    }
    
    private func setUpBackground() {
        backgroundColor = .systemGray6
    }
    
    private func composeCountLabel(with text: String) {
        countLabel.text = text
    }
}
