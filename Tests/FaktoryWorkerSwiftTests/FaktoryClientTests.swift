import XCTest
@testable import FaktoryWorkerSwift


class FaktoryClientTests: XCTestCase {
    func testConnection() {
        let configuration = ClientConfiguration(hostName: "localTestHost", wid: UUID().uuidString)
        let client = FaktoryClient(configuration: configuration)
        var result = client.connect()
        XCTAssertEqual(result, FaktoryClient.CommResult.commOk)
        
        result = client.disconnect()
        XCTAssertEqual(result, FaktoryClient.CommResult.commOk)
    }

    // Linux helpers
    static var allTests = [
        ("testConnection", testConnection),
        ]

}
