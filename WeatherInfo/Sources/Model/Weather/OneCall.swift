class OneCall: Codable {
    public let lat: Double
    public let lon: Double
    public let current: Current
    public var hourly: [Hourly]
    public let daily: [Daily]
}
