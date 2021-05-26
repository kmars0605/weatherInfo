class Current: Codable {
    public let dt: Int
    public let sunrise: Double
    public let sunset: Double
    public let temp: Double
    public let feelsLike: Double
    public let pressure: Int
    public let humidity: Int
    public let uvi: Double
    public let clouds: Int
    public let windSpeed: Double
    public let windDeg: Int
    public let weather: [CurrentWeather]

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

class CurrentWeather: Codable{
    public let main: String
    public let description: String
    public let icon: String
}


