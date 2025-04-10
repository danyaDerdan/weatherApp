import UIKit

protocol BuilderProtocol {
    func createMainModule() -> UIViewController
}

final class Builder: BuilderProtocol {
    func createMainModule() -> UIViewController {
        let viewModel = MainViewModel()
        let viewController = MainViewController()
        let networkService = NetworkService()
        let coreDataManager = CoreDataManager()
        viewModel.networkService = networkService
        viewModel.coreDataManager = coreDataManager
        viewController.viewModel = viewModel
        return viewController
    }
}
