import Foundation
import XCTest
@testable import WeatherInfo

class RepositoryTests: XCTestCase {
    func testDecode() throws {
        let jsonDecoder = JSONDecoder()
        let data = OneCall.exampleJSON.data(using: .utf8)!
        let response = try jsonDecoder.decode(OneCall.self, from: data)
        XCTAssertEqual(response.lat, 35.6776)
        XCTAssertEqual(response.lon, 139.7651)
    }
}
