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
    
    private let listTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constant.titleFont
        label.sizeToFit()
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
        addSubview(listTitleLabel)
        addSubview(countLabel)
        
        NSLayoutConstraint.activate([
            listTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            listTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            listTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            countLabel.topAnchor.constraint(equalTo: listTitleLabel.topAnchor, constant: 2),
            countLabel.bottomAnchor.constraint(equalTo: listTitleLabel.bottomAnchor, constant: -2),
            countLabel.leadingAnchor.constraint(equalTo: listTitleLabel.trailingAnchor, constant: 10),
            countLabel.widthAnchor.constraint(equalTo: countLabel.heightAnchor, constant: 2)
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
