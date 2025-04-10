import Foundation

protocol NetworkServiceProtocol {
    func fetchWeatherData(stringUrl: String, completion: @escaping (Result<ViewData.Weather, Error>) -> Void)
}


final class NetworkService: NetworkServiceProtocol {
    func fetchWeatherData(stringUrl: String, completion: @escaping (Result<ViewData.Weather, Error>) -> Void) {
        guard let url = URL(string: stringUrl) else { completion(.failure(NetworkError.urlError)); return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error { completion(.failure(error)); return }
            guard let data else { completion(.failure(NetworkError.badData)); return }
            let decoder = JSONDecoder()
            guard let model = try? decoder.decode(WeatherResponse.self, from: data) else { completion(.failure(NetworkError.decodingError)); return}
            self.fetchImage(stringUrl: "https:" + model.current.condition.icon) { result in
                switch result {
                case .failure(let error): completion(.failure(error))
                case .success(let imageData): completion(.success( ViewData.Weather(time: model.location.localtime,
                                                                                    city: model.location.name,
                                                                                    temp: model.current.temp_c,
                                                                                    condition: model.current.condition.text,
                                                                                    icon: imageData)))
                }
            }
        }.resume()
    }
    
    private func fetchImage(stringUrl: String, complition: @escaping ((Result<Data, Error>) -> Void)) {
        guard let url = URL(string: stringUrl) else { complition(.failure(NetworkError.urlError)); return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error { complition(.failure(error)); return }
            guard let data else { complition(.failure(NetworkError.badData)); return }
            complition(.success(data))
        }.resume()
    }
}

enum NetworkError: Error {
    case urlError
    case decodingError
    case badData
}
