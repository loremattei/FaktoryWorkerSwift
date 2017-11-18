import XCTest
@testable import FaktoryWorkerSwift

class FaktoryJobTests: XCTestCase {
    
    // Tests that a basic job generates the correct JSON string
    func testBasicJobEncoding() {
        let uuid = UUID().uuidString
        let jobType = "simple job"
        let jobArgs = ["1", "2", "hello"]
        var expectedResult = "{\"jobtype\":\"" + jobType + "\",\"args\":" + "["
        for string in jobArgs {
            expectedResult += "\"" + string + "\","
        }
        
        expectedResult = expectedResult[..<expectedResult.index(before: expectedResult.endIndex)] + "],"
        expectedResult += "\"queue\":\"default\",\"jid\":\"" + uuid + "\"}"
        
        let job = FaktoryJob(id: uuid, type: jobType, args: jobArgs)
        
        XCTAssertEqual(job.toJsonString(), expectedResult)
    }
    
    // Tests that a job with queue generates the correct JSON string
    func testBasicJobWithQueueEncoding() {
        let uuid = UUID().uuidString
        let jobType = "simple job"
        let jobArgs = ["1", "2", "hello"]
        let queue = "critical"
        var expectedResult = "{\"jobtype\":\"" + jobType + "\",\"args\":" + "["
        for string in jobArgs {
            expectedResult += "\"" + string + "\","
        }
        
        expectedResult = expectedResult[..<expectedResult.index(before: expectedResult.endIndex)] + "],"
        expectedResult += "\"queue\":\"critical\",\"jid\":\"" + uuid + "\"}"
        
        let job = FaktoryJob(id: uuid, type: jobType, args: jobArgs,queue: queue)
        
        XCTAssertEqual(job.toJsonString(), expectedResult)
    }
    
    // Linux helpers
    static var allTests = [
        ("testBasicJobEncoding", testBasicJobEncoding),
        ("testBasicJobWithQueueEncoding", testBasicJobWithQueueEncoding),
        ]
    
}
