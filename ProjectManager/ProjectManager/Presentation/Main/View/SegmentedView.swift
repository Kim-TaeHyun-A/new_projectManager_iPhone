//
//  SegmentedView.swift
//  ProjectManager
//
//  Created by Tiana on 2022/08/25.
//

import UIKit

private enum Constant {
    static let deselectedColor: UIColor = .black
    static let selectedColor: UIColor = .systemBlue
}

final class SegmentedView: UIView {
    private var buttons: [SegmentedButton]
    private var selectedViews: [UIView]
    var lineXPosition: NSLayoutConstraint?
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var selectedLine: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = Constant.selectedColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(buttons: [UIView], views: [UIView]) {
        self.buttons = buttons.map { SegmentedButton(label: $0) }
        self.selectedViews = views
        super.init(frame: .zero)
        setUpButtons()
        setUpGesture()
        setUpButtonStackViewLayout()
        setUpSelectedViewsLayout()
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
            
            button.setTextColor(to: color)
        }
    }
    
    private func setUpGesture() {
        buttons.forEach {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            $0.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        buttons.enumerated().forEach {
            if sender.view == $1 {
                slideView(of: $0)
            }
        }
    }
    
    private func setUpButtonStackViewLayout() {
        addSubview(buttonStackView)
        addSubview(selectedLine)
        lineXPosition = selectedLine.leadingAnchor.constraint(equalTo: buttonStackView.leadingAnchor)

        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: topAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonStackView.heightAnchor.constraint(equalToConstant: 50),
            selectedLine.heightAnchor.constraint(equalToConstant: 2),
            selectedLine.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor),
            selectedLine.widthAnchor.constraint(equalToConstant: 100),
            lineXPosition
        ].compactMap { $0 })
        updateLineLayout()
    }
    
    private func setUpSelectedViewsLayout() {
        selectedViews.enumerated().forEach { (index, selectedView) in
            addSubview(selectedView)
            selectedView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                selectedView.topAnchor.constraint(equalTo: selectedLine.bottomAnchor),
                selectedView.leadingAnchor.constraint(equalTo: leadingAnchor),
                selectedView.trailingAnchor.constraint(equalTo: trailingAnchor),
                selectedView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
            if index == 0 {
                return
            }
            selectedView.isHidden = true
        }
    }
    
    private func setUpSelectedViewLayout(of index: Int) {
        selectedViews.enumerated().forEach { (currentIndex, selectedView) in
            if index == currentIndex {
                selectedView.isHidden = false
                buttons[safe: index]?.setTextColor(to: Constant.selectedColor)
                return
            }
            selectedView.isHidden = true
            buttons[safe: currentIndex]?.setTextColor(to: Constant.deselectedColor)
        }
    }
    
    private func updateLineLayout(of index: Int = 0) {
        let newPosition = Int(frame.width) / buttons.count * index
        lineXPosition?.constant = CGFloat(newPosition)
    }
    
    func slideView(of index: Int) {
        setUpButtons(of: index)
        setUpSelectedViewLayout(of: index)
        UIView.animate(withDuration: 0.3) {
            self.updateLineLayout(of: index)
            self.layoutIfNeeded()
        }
    }
}

private final class SegmentedButton: UIControl {
    private let label: UIView
    
    init(label: UIView) {
        self.label = label
        super.init(frame: .zero)
        setUpLayout(with: label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLayout(with button: UIView) {
        addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setTextColor(to color: UIColor) {
        guard let label = label as? HeaderView else {
            return
        }
        label.listTitleLabel.textColor = color
        label.countLabel.backgroundColor = color
    }
}
