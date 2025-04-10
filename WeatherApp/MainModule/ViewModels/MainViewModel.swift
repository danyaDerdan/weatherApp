import Foundation

private struct Constants {
    static let stringUrl = "https://api.weatherapi.com/v1/current.json?key=5776ff030b0448ab8eb53432251004&q="
    static let key = "cities"
    
}

protocol MainViewModelProtocol {
    var updateViewData: ((ViewData) -> Void)? { get set }
    func viewDidLoad()
    func findButtonTapped(with city: String)
}

final class MainViewModel: MainViewModelProtocol {
    var updateViewData: ((ViewData) -> Void)?
    var networkService: NetworkServiceProtocol?
    
    func viewDidLoad() {
        loadCities()
    }
    
    func findButtonTapped(with city: String) {
        guard checkUniq(city: city), !city.isEmpty else { return }
        networkService?.fetchWeatherData(stringUrl: Constants.stringUrl + city) { result in
            switch result {
            case .failure(_): DispatchQueue.main.async { self.updateViewData?(.failure) }
            case .success(let data):
                guard self.checkUniq(city: data.city) else { return }
                self.saveCity(city)
                self.loadCities()
            }
        }
    }
    
    private func saveCity(_ city: String) {
        let lastCities = UserDefaults.standard.object(forKey: Constants.key) as? [String] ?? []
        UserDefaults.standard.set([city] + lastCities, forKey: Constants.key)
    }
    
    private func checkUniq(city: String) -> Bool {
        guard let cities = UserDefaults.standard.object(forKey: Constants.key) as? [String] else { return true }
        return !cities.contains(city)
    }
    
    private func loadCities() {
        let cities = UserDefaults.standard.object(forKey: Constants.key) as? [String] ?? []

        var results = [ViewData.Weather]()
        let dispatchGroup = DispatchGroup()

        for city in cities {
            dispatchGroup.enter()
            networkService?.fetchWeatherData(stringUrl: Constants.stringUrl + city) { result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                    dispatchGroup.leave()
                case .success(var data):
                    DispatchQueue.main.async {
                        data.time = self.correctDate(data.time)
                        results.append(data)
                        dispatchGroup.leave()
                    }
                }
            }
            
        }
        dispatchGroup.notify(queue: .main) {
            self.updateViewData?(.success(results))
        }
    }
    
    private func correctDate(_ date: String) -> String {
        return String(date.split(separator: " ")[1])
    }
    
}
