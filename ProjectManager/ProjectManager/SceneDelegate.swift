//
//  ProjectManager - SceneDelegate.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private let networkService = NetworkServiceAF()
    private lazy var dependencies = SceneDIContainer.Dependencies(networkService: networkService,
                                                                    networkCondition: NetworkCondition())
    private lazy var sceneDIContainer = SceneDIContainer(dependencies: dependencies)
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let rootViewController = sceneDIContainer
            .makeMainViewController(with: sceneDIContainer)
        
        networkService.delegate = rootViewController
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UINavigationController(rootViewController: rootViewController)
        window?.makeKeyAndVisible()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        sceneDIContainer.projectUseCase.backUp()
    }
}
