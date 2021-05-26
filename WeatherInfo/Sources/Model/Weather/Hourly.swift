class Hourly: Codable {
    public let dt: Int
    public let temp: Double
    public let feelsLike: Double
    public let pressure: Int
    public let humidity: Int
    public let uvi: Double
    public let clouds: Int
    public let windSpeed: Double
    public let windDeg: Int
    public let weather: [HourlyWeather]
    public let pop: Double

    public enum CodingKeys: String, CodingKey {
        case dt
        case temp
        case feelsLike = "feels_like"
        case pressure
        case humidity
        case uvi
        case clouds
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather
        case pop
    }
}

class HourlyWeather: Codable{
    public let main: String
    public let description: String
    public let icon:String
}
