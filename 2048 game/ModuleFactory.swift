//
//  ModuleFactory.swift
//  2048 game
//
//  Created by Simon Pegg on 13.07.2022.
//

import Foundation
import UIKit

enum TypesOfScreen {
    case game
    case settings
}
    

protocol FactoryProtocol {
    func makeModule(type: TypesOfScreen) -> UIViewController
}

class ModuleFactory: FactoryProtocol {
    
    var coordinator: CoordinatorProtocol?
    
    func makeModule(type: TypesOfScreen) -> UIViewController {
        var controller = UIViewController()
        switch type {
        case .game:
            guard let safeCoordinator = coordinator else {break}
            controller = GameViewController(coordinator: safeCoordinator)
            
           
        case .settings:
            controller = UIViewController()
            controller.view.backgroundColor = .blue
            
        }
        return controller
    }
//    init (coordinator: CoordinatorProtocol) {
//        self.coordinator = coordinator
//    }
    
    
}
