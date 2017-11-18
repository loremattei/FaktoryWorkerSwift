import XCTest
@testable import FaktoryWorkerSwift

class FaktoryJobTests: XCTestCase {
    
    // Tests that a basic job generates the correct JSON string
    func testBasicJobEncoding() {
        let uuid = UUID().uuidString
        let jobType = "simple job"
        let jobArgs = ["1", "2", "hello"]
        var expectedResult = "{\"jid\":\"" + uuid + "\",\"jobtype\":\"" + jobType + "\",\"args\":" + "["
        for string in jobArgs {
            expectedResult += "\"" + string + "\","
        }
        expectedResult = expectedResult[..<expectedResult.index(before: expectedResult.endIndex)] + "]}"
        
        let job = FaktoryJob(id: uuid, type: jobType, args: jobArgs)
        
        XCTAssertEqual(job.toJsonString(), expectedResult)
    }
    
    // Linux helpers
    static var allTests = [
        ("testBasicJobEncoding", testBasicJobEncoding),
        ]
    
}
