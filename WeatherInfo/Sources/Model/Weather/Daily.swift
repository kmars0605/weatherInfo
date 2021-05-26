class Daily: Codable {
    public let dt: Int
    public let sunrise: Double
    public let sunset: Double
    public let temp: DailyTemp
    public let pressure: Int
    public let humidity: Int
    public let uvi: Double
    public let clouds: Int
    public let windSpeed: Double
    public let windDeg: Int
    public let weather: [DailyWeather]
    public let pop: Double

    public enum CodingKeys: String, CodingKey {
        case dt
        case sunrise
        case sunset
        case temp
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

class DailyTemp: Codable{
    public let day: Double
    public let min: Double
    public let max: Double
    public let night: Double
}

class DailyWeather: Codable{
    public let main: String
    public let description: String
    public let icon:String
}
