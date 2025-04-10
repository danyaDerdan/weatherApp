import UIKit

class MainViewController: UIViewController {
    var viewModel: MainViewModelProtocol?
    private var weatherData = [ViewData.Weather]()
    private lazy var tableView = createTableView()
    private lazy var textField = createTextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        connectToViewModel()
        viewModel?.viewDidLoad()
        textField.isEnabled = true
    }
    
    func connectToViewModel() {
        viewModel?.updateViewData = { [weak self] viewData in
            switch viewData {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.weatherData = data; self?.tableView.reloadData()
                }
            }
        }
    }
}

private extension MainViewController {
    
    func createTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(WeatherCell.self, forCellReuseIdentifier: "WeatherCell")
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        return tableView
    }
    
    func createTextField() -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter city name"
        textField.delegate = self
        view.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textField.heightAnchor.constraint(equalToConstant: 40),
            textField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        return textField
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeatherCell else { return UITableViewCell() }
        cell.configure(with: weatherData[indexPath.row])
        return cell
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel?.findButtonTapped(with: textField.text ?? "")
        textField.resignFirstResponder()
        return true
    }
}
