struct WeatherResponse: Decodable {
    
    let location: Location
    let current: Current
    
    struct Location: Codable {
        let name: String
        let localtime: String
    }
    
    struct Current: Codable {
        let temp_c: Double
        let condition: Condition
    }
    
    struct Condition: Codable {
        let text: String
        let icon: String
    }
}
