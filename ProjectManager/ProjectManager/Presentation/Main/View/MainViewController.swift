//
//  MainViewController.swift
//  ProjectManager
//
//  Created by Tiana, mmim on 2022/07/04.
//

import RxSwift
import RxCocoa

private enum ImageConstant {
    static let connected = "wifi"
    static let disconnected = "wifi.slash"
    static let load = "icloud.and.arrow.down"
}

final class MainViewController: UIViewController {
    private let mainView: MainView!
    private var viewModel: MainVCViewModelProtocol?
    private var sceneDIContainer: SceneDIContainer?
    private let disposeBag = DisposeBag()
    
    init(with viewVCModel: MainVCViewModelProtocol, viewModel: [ProjectListViewModelProtocol], _ sceneDIContainer: SceneDIContainer) {
        self.viewModel = viewVCModel
        self.mainView = MainView(projectListViewModels: viewModel)
        self.sceneDIContainer = sceneDIContainer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableDelegate()
        setUpNavigationItem()
    }
    
    private func setUpTableDelegate() {
        mainView.baseView.projects.forEach { $0.tableView.projectDelegate = self }
    }
    
    private func setUpNavigationItem() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        let loadButton = UIBarButtonItem(image: UIImage(systemName: ImageConstant.load),
                                         style: .done,
                                         target: nil,
                                         action: nil)
        let networkImage = UIImage(systemName: ImageConstant.connected)?
            .withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
        let networkConditionSign = UIBarButtonItem(image: networkImage,
                                                   style: .plain,
                                                   target: nil,
                                                   action: nil)
        
        navigationItem.title = "Project Manager"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "History",
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
        navigationItem.rightBarButtonItems = [addButton, loadButton, networkConditionSign]
        didTapHistoryButton()
        didTapAddButton()
        didTapLoadButton()
        networkConditionSign.isEnabled = false
        NetworkCondition.sharedInstance.delegate = self
    }
    
    private func didTapHistoryButton() {
        guard let historyButton = navigationItem.leftBarButtonItem else {
            return
        }
        
        historyButton.rx.tap
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.presentHistoryPopOver(source: historyButton)
            })
            .disposed(by: disposeBag)
    }
    
    private func didTapAddButton() {
        guard let addButton = navigationItem.rightBarButtonItem else {
            return
        }
        
        addButton.rx.tap
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.presentRegistrationView()
            })
            .disposed(by: disposeBag)
    }
    
    private func didTapLoadButton() {
        guard let loadButton = navigationItem.rightBarButtonItems?[1] else {
            return
        }
        
        loadButton.rx.tap
            .asObservable()
            .subscribe(onNext: { [weak self] in
                self?.presentAlert()
            })
            .disposed(by: disposeBag)
    }
    
    private func presentHistoryPopOver(source: UIBarButtonItem) {
        guard let historyViewController = sceneDIContainer?.makeHistoryViewController(with: source) else {
            return
        }
        
        present(historyViewController, animated: true)
    }
    
    private func presentAlert() {
        let alertAction = UIAlertAction(title: "확인", style: .destructive) { [weak self]_ in
            guard let self = self else {
                return
            }
            
            self.viewModel?.didTapLoadButton()
        }
        
        guard let next = sceneDIContainer?
            .makeAlertController(over: self,
                                 title: "서버 데이터를 사용자 기기로 동기화할까요?",
                                 confirmButton: alertAction) else {
            return
        }
        
        present(next, animated: true)
    }
    
    private func presentRegistrationView() {
        guard let next = sceneDIContainer?.makeRegistrationViewController() else {
            return
        }
        
        next.modalPresentationStyle = .overCurrentContext
        next.modalTransitionStyle = .crossDissolve
        present(next, animated: true)
    }
}

extension MainViewController: ProjectListViewDelegate {
    func didTap(cell: ProjectCell) {
        viewModel?.didTapCell(cell.contentID)
        presentViewController(cell: cell)
    }
    
    func didLongPress(cell: ProjectCell) {
        presentPopOver(cell)
    }
    
    private func presentViewController(cell: ProjectCell) {
        guard let content = viewModel?.currnetProjectEntity,
              let next = sceneDIContainer?.makeDetailViewController(with: content) else {
            return
        }
        
        next.modalPresentationStyle = .overCurrentContext
        next.modalTransitionStyle = .crossDissolve
        present(next, animated: true)
    }
    
    private func presentPopOver(_ cell: ProjectCell) {
        guard let popOverViewController = sceneDIContainer?.makePopOverViewController(with: cell) else {
            return
        }
        
        present(popOverViewController, animated: true)
    }
}

extension MainViewController: NetworkConditionDelegate {
    func applyNetworkEnable() {
        navigationItem.rightBarButtonItems?[2].image = UIImage(systemName: ImageConstant.connected)?
            .withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
    }
    
    func applyNetworkUnable() {
        navigationItem.rightBarButtonItems?[2].image = UIImage(systemName: ImageConstant.disconnected)?
            .withTintColor(.systemRed, renderingMode: .alwaysOriginal)
    }
}
