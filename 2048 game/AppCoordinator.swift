import Foundation

protocol CoordinatorProtocol {
    func start()
}
protocol Coordinated {
    var coordinator: CoordinatorProtocol {get set}
}
class AppCoordinator: CoordinatorProtocol {
    func start() {
        self.showFlow()
    }
    fileprivate let factory: FactoryProtocol
    
    var childCoordinators: [CoordinatorProtocol] = []
    
    init(with factory: FactoryProtocol) {
        self.factory = factory

    }
}

extension AppCoordinator {
    func showFlow() {
        
    }
}
