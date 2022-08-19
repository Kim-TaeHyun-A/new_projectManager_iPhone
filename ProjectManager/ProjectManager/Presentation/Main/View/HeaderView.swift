//
//  HeaderView.swift
//  ProjectManager
//
//  Created by Tiana on 2022/08/20.
//

import UIKit

final class HeaderView: UIView {
    private let listTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.sizeToFit()
        return label
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        
        func round() {
            label.layer.masksToBounds = true
            label.layer.cornerRadius = 20
        }
        
        func text() {
            label.textColor = .white
            label.text = "0"
            label.textAlignment = .center
            label.font = .preferredFont(forTextStyle: .body)
        }
        
        round()
        text()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .black
        
        return label
    }()
    
    init(status: ProjectStatus) {
        super.init(frame: .zero)
        
        setUpLayout()
        setUpTitle(title: status.string)
        setUpBackground()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    private func setUpTitle(title: String) {
        listTitleLabel.text = title
    }
    
    private func setUpBackground() {
        backgroundColor = .systemGray6
    }
    
    func composeCountLabel(with text: String) {
        countLabel.text = text
    }
}
