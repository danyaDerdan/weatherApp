import UIKit

class MainViewController: UIViewController {
    var viewModel: MainViewModelProtocol?
    private var weatherData = [ViewData.Weather]()
    private lazy var tableView = createTableView()
    private lazy var textField = createTextField()
    private lazy var cancelButton = createCancelButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Weather"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        connectToViewModel()
        viewModel?.viewDidLoad()
        textField.isEnabled = true
        cancelButton.isEnabled = true
    }
    
    func connectToViewModel() {
        viewModel?.updateViewData = { [weak self] viewData in
            switch viewData {
            case .success(let data): self?.weatherData = data; self?.tableView.reloadData()
            case .failure: self?.showAlert()
            }
        }
    }
}

private extension MainViewController {
    
    func createTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(WeatherCell.self, forCellReuseIdentifier: "WeatherCell")
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.75),
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
        textField.backgroundColor = .systemGray6
        textField.textAlignment = .center
        textField.layer.cornerRadius = 10
        view.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -20),
            textField.heightAnchor.constraint(equalToConstant: 40),
            textField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        return textField
    }
    
    func createCancelButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 40),
            button.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ])
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
        
    }
    
    @objc func cancelButtonTapped() {
        textField.resignFirstResponder()
    }

    func showAlert() {
        let alert = UIAlertController(
            title: "Город не найден",
            message: nil,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeatherCell else { return UITableViewCell() }
        cell.configure(with: weatherData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel?.findButtonTapped(with: textField.text ?? "")
        textField.resignFirstResponder()
        return true
    }
}
