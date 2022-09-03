//
//  ToastDelegate.swift
//  ProjectManager
//
//  Created by Tiana on 2022/09/04.
//

import UIKit

protocol ToastDelegte: UIViewController {
    func show(message: String)
}

extension ToastDelegte {
    func makeLabel(frame: CGRect, message: String) -> UILabel {
        let label = UILabel(frame: frame)
        label.backgroundColor = .systemGray3
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.text = message
        return label
    }
}
