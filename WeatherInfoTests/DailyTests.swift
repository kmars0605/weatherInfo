import Foundation
import XCTest
@testable import WeatherInfo

class DailyTests: XCTestCase {
    func testDecode() throws {
        let jsonDecoder = JSONDecoder()
        let data = Daily.exampleJSON.data(using: .utf8)!
        let response = try jsonDecoder.decode([Daily].self, from: data)
        XCTAssertEqual(response[0].temp.min, 7.9)
        XCTAssertEqual(response[0].temp.max, 15.3)
        XCTAssertEqual(response[0].humidity, 34)
        XCTAssertEqual(response[0].clouds, 0)
        XCTAssertEqual(response[0].weather[0].main, "Clear")
        XCTAssertEqual(response[0].weather[0].description, "clear sky")
        XCTAssertEqual(response[0].weather[0].icon, "01d")
    }
}
