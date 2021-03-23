import Foundation

struct Current: Codable {
    let dt: Int
    let sunrise: Double
    let sunset: Double
    let temp: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int
    let uvi: Double
    let clouds: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [CurrentWeather]

    public enum CodingKeys: String, CodingKey {
        case dt
        case sunrise
        case sunset
        case temp
        case feelsLike = "feels_like"
        case pressure
        case humidity
        case uvi
        case clouds
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather
    }
}

struct CurrentWeather: Codable{
    let main: String
    let description: String
    let icon: String
}


