import Foundation
import XCTest
@testable import WeatherInfo

class Currentests: XCTestCase {
    func testDecode() throws {
        let jsonDecoder = JSONDecoder()
        let data = Current.exampleJSON.data(using: .utf8)!
        let response = try jsonDecoder.decode(Current.self, from: data)
        XCTAssertEqual(response.temp, 15.3)
        XCTAssertEqual(response.humidity, 50)
        XCTAssertEqual(response.clouds, 20)
        XCTAssertEqual(response.weather[0].main, "Clouds")
        XCTAssertEqual(response.weather[0].description, "few clouds")
        XCTAssertEqual(response.weather[0].icon, "02d")
    }
}
