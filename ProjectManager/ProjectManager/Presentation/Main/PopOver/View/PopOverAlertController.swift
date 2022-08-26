//
//  PopOverAlertController.swift
//  ProjectManager
//
//  Created by Tiana on 2022/08/27.
//

import UIKit

final class PopOverAlertController: UIAlertController {
    private var viewModel: PopOverViewModelProtocol?
    private var firstButton: UIAlertAction?
    private var secondButton: UIAlertAction?
    
    init(viewModel: PopOverViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel = viewModel
        setUpButtons()
        addActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpButtons() {
        guard let (first, second) = viewModel?.status else {
            return
        }
        
        firstButton = UIAlertAction(title: first.buttonTitle, style: .default) { [weak self] _ in
            self?.viewModel?.moveCell(by: self?.firstButton?.title)
            self?.dismiss(animated: true)
        }
        secondButton = UIAlertAction(title: second.buttonTitle, style: .default) { [weak self] _ in
            self?.viewModel?.moveCell(by: self?.secondButton?.title)
            self?.dismiss(animated: true)
        }
    }
    
    private func addActions() {
        let cancelButton = UIAlertAction(title: "취소", style: .destructive)
        guard let firstButton = firstButton,
              let secondButton = secondButton else {
            return
        }
        
        addAction(firstButton)
        addAction(secondButton)
        addAction(cancelButton)
    }
}
