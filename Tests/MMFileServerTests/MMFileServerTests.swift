import XCTest
@testable import MMFileServer

class MMFileServerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(MMFileServer().text, "Hello, World!")
    }


    static var allTests : [(String, (MMFileServerTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
