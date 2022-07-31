//
//  SceneDelegate.swift
//  2048 game
//
//  Created by Simon Pegg on 13.07.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let factory = ModuleFactory()
        let appCoordinator = AppCoordinator(with: factory)
        factory.coordinator = appCoordinator
        
        let firstController = factory.makeModule(type: .game)
        

        guard let scene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: scene)
        window?.makeKeyAndVisible()

//        let tabBarController = UITabBarController()
//
//        let loginVC: LoginViewController = {
//            let controller = LoginViewController()
//            controller.tabBarItem = UITabBarItem(title: "Profile", image: .init(imageLiteralResourceName: "profile") , tag: 0)
//            controller.view.backgroundColor = .white
//            let myFabric = MyLoginFactory()
//            controller.delegate = myFabric.factory()
//            return controller
//        }()
//
//        let feedVC: FeedViewController = {
//            let controller = FeedViewController()
//            controller.view.backgroundColor = .blue
//            controller.tabBarItem = UITabBarItem(title: "Feed", image: .init(imageLiteralResourceName: "connect") , tag: 1)
//            return controller
//        }()
//        let feedNavVC = UINavigationController(rootViewController: feedVC)
//        let profileNavVC = UINavigationController(rootViewController: loginVC)
//        profileNavVC.navigationBar.isHidden = true
//        tabBarController.viewControllers = [feedNavVC , profileNavVC]
//        tabBarController.tabBar.backgroundColor = .white
        window?.rootViewController = firstController
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

