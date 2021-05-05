class Daily: Codable {
    let dt: Int
    let sunrise: Double
    let sunset: Double
    let temp: DailyTemp
    let pressure: Int
    let humidity: Int
    let uvi: Double
    let clouds: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [DailyWeather]
    let pop: Double

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
    let day: Double
    let min: Double
    let max: Double
    let night: Double
}

class DailyWeather: Codable{
    let main: String
    let description: String
    let icon:String
}
