import Foundation
import XCTest
@testable import WeatherInfo

class HourlyTests: XCTestCase {
    func testDecode() throws {
        let jsonDecoder = JSONDecoder()
        let data = Hourly.exampleJSON.data(using: .utf8)!
        let response = try jsonDecoder.decode([Hourly].self, from: data)
        XCTAssertEqual(response[0].temp, 15.3)
        XCTAssertEqual(response[0].humidity, 50)
        XCTAssertEqual(response[0].clouds, 20)
        XCTAssertEqual(response[0].weather[0].main, "Clouds")
        XCTAssertEqual(response[0].weather[0].description, "few clouds")
        XCTAssertEqual(response[0].weather[0].icon, "02d")
        XCTAssertEqual(response[0].pop, 0)
    }
}
