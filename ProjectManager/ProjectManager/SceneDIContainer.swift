//
//  SceneDIContainer.swift
//  ProjectManager
//
//  Created by Tiana, mmim on 2022/07/27.
//

import UIKit

final class SceneDIContainer {
    struct Dependencies {
        let networkService: NetworkServiceProtocol
        let networkCondition: NetworkCondition
    }
    
    private let dependencies: Dependencies

    lazy var projectUseCase = makeProjectUseCase()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Manager
    
    private func makePersistentManager() -> PersistentManager {
        return PersistentManager()
    }
    
    private func makeRemoteManager() -> RemoteManager {
        return RemoteManager(networkServie: dependencies.networkService)
    }
    
    private func makeHistoryManager() -> HistoryManager {
        return HistoryManager()
    }
    
    // MARK: - Repository
    
    private func makeProjectRepository() -> PersistentRepository {
        return PersistentRepository(persistentManager: makePersistentManager())
    }
    
    private func makeRemoteRepository() -> RemoteRepository {
        return RemoteRepository(networkManger: makeRemoteManager())
    }
    
    private func makeHistoryRepository() -> HistoryRepository {
        return HistoryRepository(historyManager: makeHistoryManager())
    }
    
    // MARK: - Use Cases
    
    private func makeProjectUseCase() -> ProjectUseCaseProtocol {
        return DefaultProjectUseCase(projectRepository: makeProjectRepository(),
                                     remoteRepository: makeRemoteRepository(),
                                     historyRepository: makeHistoryRepository())
    }
    
    // MARK: - Main
    
    private func makeMainVCViewModel() -> MainVCViewModel {
        return MainVCViewModel(projectUseCase: projectUseCase,
                               networkCondition: dependencies.networkCondition)
    }
    
    private func makeMainViewModel() -> [ProjectListViewModel] {
        return [ProjectListViewModel(projectUseCase: projectUseCase, status: .todo),
                ProjectListViewModel(projectUseCase: projectUseCase, status: .doing),
                ProjectListViewModel(projectUseCase: projectUseCase, status: .done)]
    }
    
    func makeMainViewController(with sceneDIContainer: SceneDIContainer) -> MainViewController {
        return MainViewController(with: makeMainVCViewModel(), viewModel: makeMainViewModel(), sceneDIContainer)
    }
    
    // MARK: - PopOver
    
    private func makePopOverViewModel(with cell: ProjectCell) -> PopOverViewModel {
        return PopOverViewModel(projectUseCase: projectUseCase, cell: cell)
    }
    
    func makePopOverViewController(with cell: ProjectCell) -> PopOverViewController {
        return PopOverViewController(with: makePopOverViewModel(with: cell))
    }
    
    func makerPopOverAlertController(with cell: ProjectCell) -> PopOverAlertController {
        return PopOverAlertController(viewModel: makePopOverViewModel(with: cell))
    }
    
    // MARK: - History
    
    private func makeHistoryViewModel() -> HistoryViewModel {
        return HistoryViewModel(projectUseCase: projectUseCase)
    }
    
    func makeHistoryViewController(with source: UIBarButtonItem) -> HistoryViewController {
        return HistoryViewController(with: makeHistoryViewModel(), source: source)
    }
    
    // MARK: - Detail
    
    private func makeDetailViewModel(with projectEntity: ProjectEntity) -> DetailViewModel {
        return DetailViewModel(projectUseCase: projectUseCase, content: projectEntity)
    }
    
    func makeDetailViewController(with projectEntity: ProjectEntity) -> DetailViewController {
        return DetailViewController(with: makeDetailViewModel(with: projectEntity))
    }
    
    // MARK: - Registration
    
    private func makeRegistrationViewModel() -> RegistrationViewModel {
        return RegistrationViewModel(projectUseCase: projectUseCase)
    }
    
    func makeRegistrationViewController() -> RegistrationViewController {
        return RegistrationViewController(with: makeRegistrationViewModel())
    }
    
    // MARK: - Alert
    
    func makeAlertController(over: UIViewController, title: String, confirmButton: UIAlertAction?) -> AlertController {
        return AlertController(over: over, title: title, confirmButton: confirmButton)
    }
    
}
