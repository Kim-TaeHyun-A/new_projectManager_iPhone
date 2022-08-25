//
//  SegmentedView.swift
//  ProjectManager
//
//  Created by Tiana on 2022/08/25.
//

import UIKit

private enum Constant {
    static let deselectedColor: UIColor = .black
    static let selectedColor: UIColor = .red
}

final class SegmentedView: UIView {
    private var buttons: [SegmentedButton]
    private var selectedViews: [UIView]
    var selectedTextColor: UIColor = Constant.selectedColor
    var selectedLineColor: UIColor = Constant.selectedColor
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init(buttons: [UIView], views: [UIView]) {
        self.buttons = buttons.map { SegmentedButton(button: $0) }
        self.selectedViews = views
        super.init(frame: .zero)
        setUpButtons()
        setUpButtonStackViewLayout()
        setUpSelectedViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpButtons(of selectedIndex: Int = 0) {
        var color: UIColor = Constant.deselectedColor
        
        buttons.enumerated().forEach { (index, button) in
            if index == selectedIndex {
                color = Constant.selectedColor
            } else {
                color = Constant.deselectedColor
            }
            
            button.toggleSelectedLine()
            button.changeTextColor(to: color)
            button.changeLineColor(to: color)
        }
    }
    
    private func setUpButtonStackViewLayout() {
        addSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: topAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonStackView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setUpSelectedViewLayout(of index: Int = 0) {
        guard let selectedView = selectedViews[safe: index] else {
            return
        }
        
        addSubview(selectedView)
        
        NSLayoutConstraint.activate([
            selectedView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor),
            selectedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectedView.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectedView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func slideView(of index: Int) {
        setUpButtons(of: index)
        UIView.animate(withDuration: 0.3) {
            self.setUpSelectedViewLayout(of: index)
        }
    }
}

private final class SegmentedButton: UIControl {
    private let button: UIView
    private var textColor: UIColor = Constant.deselectedColor
    
    private lazy var selectedLine: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: frame.height, width: frame.width, height: 2))
        view.backgroundColor = Constant.deselectedColor
        view.isHidden = true
        return view
    }()
    
    init(button: UIView) {
        self.button = button
        super.init(frame: .zero)
        setUpButton(with: button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpButton(with button: UIView) {
        isUserInteractionEnabled = true
        setUpLayout(with: button)
    }
    
    private func setUpLayout(with button: UIView) {
        addSubview(button)
        addSubview(selectedLine)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: selectedLine.topAnchor)
        ])
    }
    
    func changeLineColor(to color: UIColor) {
        selectedLine.backgroundColor = color
    }
    
    func changeTextColor(to color: UIColor) {
        textColor = color
    }
    
    func toggleSelectedLine() {
        selectedLine.isHidden = !selectedLine.isHidden
    }
}
