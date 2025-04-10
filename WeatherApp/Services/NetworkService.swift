import Foundation

protocol NetworkServiceProtocol {
    func fetchWeatherData(for city: String,  stringUrl: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void)
    func fetchImage(stringUrl: String, complition: @escaping ((Result<Data, Error>) -> Void))
}


final class NetworkService: NetworkServiceProtocol {
    func fetchWeatherData(for city: String,  stringUrl: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        guard let url = URL(string: stringUrl) else { completion(.failure(NetworkError.urlError)); return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error { completion(.failure(error)) }
            guard let data else { completion(.failure(NetworkError.badData)); return }
            let decoder = JSONDecoder()
            guard let result = try? decoder.decode(WeatherResponse.self, from: data) else { completion(.failure(NetworkError.decodingError)); return}
            completion(.success(result))
        }.resume()
    }
    
    func fetchImage(stringUrl: String, complition: @escaping ((Result<Data, Error>) -> Void)) {
        guard let url = URL(string: stringUrl) else { complition(.failure(NetworkError.urlError)); return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error { complition(.failure(error)) }
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
