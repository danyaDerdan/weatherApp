import Foundation

enum ViewData {
    case success(Weather)
    
    struct Weather {
        var time: String
        var city: String
        var temp: Double
        var condition: String
        var icon: Data
    }
}
