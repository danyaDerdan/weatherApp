private struct Constants {
    static let stringUrl = "https://api.weatherapi.com/v1/current.json?key=5776ff030b0448ab8eb53432251004&q="
    
}

protocol MainViewModelProtocol {
    var updateViewData: ((ViewData) -> Void)? { get set }
    func viewDidLoad()
    func findButtonTapped(with string: String)
}

final class MainViewModel: MainViewModelProtocol {
    var updateViewData: ((ViewData) -> Void)?
    var networkService: NetworkServiceProtocol?
    var coreDataManager: CoreDataManagerProtocol?
    
    func viewDidLoad() {
        updateViewData?(.success(coreDataManager?.getWeather() ?? []))
    }
    
    func findButtonTapped(with string: String) {
        networkService?.fetchWeatherData(for: string, stringUrl: Constants.stringUrl + string) { result in
            switch result {
            case .failure(let error): print(error.localizedDescription) //обработать алертом updateViewData(.failure)
            case .success(let weather): self.saveWeatherToCoreData(weather)
                
            }
        }
    }
    
    private func saveWeatherToCoreData(_ weather: WeatherResponse) {
        networkService?.fetchImage(stringUrl: weather.current.condition.icon) { result in
            switch result {
            case .failure(let error): print(error.localizedDescription)
            case .success(let data):
                self.coreDataManager?.saveWeather(ViewData.Weather(time: weather.location.localtime, //обработать
                                                              city: weather.location.name,
                                                              temp: weather.current.temp_c,
                                                              condition: weather.current.condition.text,
                                                              icon: data))
            }
        }
    }
    
    
}
