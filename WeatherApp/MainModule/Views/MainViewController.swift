import UIKit

class MainViewController: UIViewController {
    var viewModel: MainViewModelProtocol?
    private var weatherData: [ViewData.Weather]?
    private lazy var tableView = createTableView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func connectToViewModel() {
        viewModel?.updateViewData = { [weak self] viewData in
            switch viewData {
            case .success(let data): self?.weatherData = data; self?.tableView.reloadData()
            }
        }
    }
}

private extension MainViewController {
    func createTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }
}

