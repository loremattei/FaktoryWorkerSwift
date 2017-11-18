import XCTest
@testable import FaktoryWorkerSwift

class FaktoryWorkerSwiftTests: XCTestCase {
    
    // Integration test for the system:
    // - push some jobs to differents queues
    // - start the worker, fetch the jobs and execute them
    func testJobLifeCycle() {
        // Create the client and connect
        let configuration = ClientConfiguration(hostName: "localTestHost", wid: UUID().uuidString)
        let client = FaktoryClient(configuration: configuration)
        var result = client.connect()
        XCTAssertEqual(result, FaktoryClient.CommResult.commOk)
        
        // Create some jobs and push them
        let job1 = FaktoryJob(id: UUID().uuidString, type: "stdJob", args: ["1", "2", "OK"])
        let job2 = FaktoryJob(id: UUID().uuidString, type: "stdJob", args: ["1", "2", "OK"], queue: "critical")
        let job3 = FaktoryJob(id: UUID().uuidString, type: "stdJob", args: ["1", "2", "FAIL"])
        
        XCTAssertEqual(client.push(job: job1), .commOk)
        XCTAssertEqual(client.push(job: job2), .commOk)
        XCTAssertEqual(client.push(job: job3), .commOk)
        
        result = client.disconnect()
        XCTAssertEqual(result, FaktoryClient.CommResult.commOk)
    }
    
    // Linux helpers
    static var allTests = [
        ("testJobLifeCycle", testJobLifeCycle),
        ]
    
}
