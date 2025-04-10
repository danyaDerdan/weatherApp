import UIKit

protocol BuilderProtocol {
    func createMainModule() -> UIViewController
}

final class Builder: BuilderProtocol {
    func createMainModule() -> UIViewController {
        let viewModel = MainViewModel()
        let viewController = MainViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}
