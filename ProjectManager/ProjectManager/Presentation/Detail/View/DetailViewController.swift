//
//  DetailViewController.swift
//  ProjectManager
//
//  Created by Tiana, mmim on 2022/07/07.
//

import RxSwift
import RxCocoa

private enum Constant {
    static let edit = "edit"
    static let done = "done"
    static let save = "save"
    static let cancel = "cancel"
}

final class DetailViewController: UIViewController {
    private var viewModel: DetailViewModel?
    private let modalView = ModalView(frame: .zero)
    private let disposeBag = DisposeBag()
    private var topConstraint: NSLayoutConstraint?
    
    init(with viewModel: DetailViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpAttribute()
        bind()
        setUpLayout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first, touch.view == self.view {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func setUpAttribute() {
        view.backgroundColor = .black.withAlphaComponent(0.5)
        modalView.registerNotification()
        modalView.navigationBar.modalTitle.text = viewModel?.content?.status.string
        modalView.delegate = self
        viewModel?.delegate = self
    }
    
    private func setUpLayout() {
        view.addSubview(modalView)
        modalView.translatesAutoresizingMaskIntoConstraints = false
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            topConstraint = modalView.topAnchor.constraint(equalTo: view.topAnchor,
                                                           constant: modalView.defaultTopConstant)
            
            NSLayoutConstraint.activate([
                modalView.widthAnchor.constraint(equalToConstant: ModalConstant.modalFrameWidth),
                modalView.heightAnchor.constraint(equalToConstant: ModalConstant.modalFrameHeight),
                modalView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                topConstraint
            ].compactMap { $0 })
        default: // .phone
            topConstraint = modalView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor)
            
            NSLayoutConstraint.activate([
                modalView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                modalView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                modalView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                topConstraint
            ].compactMap { $0 })
        }
    }
    
    private func bind() {
        bindView()
        bindButton()
    }
    
    private func bindView() {
        viewModel?.mode
            .filter { $0 == .display}
            .bind { [weak self] _ in
                self?.setUpDisplayView()
            }
            .disposed(by: disposeBag)
        
        viewModel?.mode
            .filter { $0 == .edit}
            .bind { [weak self] _ in
                self?.setUpEditView()
            }
            .disposed(by: disposeBag)
    }
    
    private func bindButton() {
        bindLeftButton()
        bindRightButton()
    }
    
    private func bindLeftButton() {
        modalView.navigationBar.leftButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.viewModel?.didTapLeftButton()
            }
            .disposed(by: disposeBag)
    }
    
    private func bindRightButton() {
        modalView.navigationBar.rightButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.viewModel?.didTapRightButton()
            }
            .disposed(by: disposeBag)
    }
    
    private func setUpDisplayView() {
        guard let project = viewModel?.content else {
            return
        }
        modalView.navigationBar.leftButton.setTitle(Constant.edit, for: .normal)
        modalView.navigationBar.rightButton.setTitle(Constant.done, for: .normal)
        modalView.compose(content: project)
        modalView.isUserInteractionEnabled(false)
    }
    
    private func setUpEditView() {
        modalView.navigationBar.leftButton.setTitle(Constant.cancel, for: .normal)
        modalView.navigationBar.rightButton.setTitle(Constant.save, for: .normal)
        modalView.isUserInteractionEnabled(true)
    }
}

extension DetailViewController: ModalViewDelegate {
    func changeModalViewTopConstant(to constant: Double) {
        topConstraint?.constant = constant
        view.layoutIfNeeded()
    }
}

extension DetailViewController: DetailViewModelDelegate {
    func close() {
        dismiss(animated: true, completion: nil)
    }
    
    func save() {
        guard let content = viewModel?.content else {
            return
        }
        
        let newContent = modalView.editContent(content)
        viewModel?.update(newContent)
    }
}
