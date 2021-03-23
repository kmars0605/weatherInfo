struct OneCall: Codable {
    let lat: Double
    let lon: Double
    let current: Current
    var hourly: [Hourly]
    let daily: [Daily]
}
