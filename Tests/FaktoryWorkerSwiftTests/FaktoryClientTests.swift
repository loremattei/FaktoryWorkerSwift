import XCTest
@testable import FaktoryWorkerSwift


class FaktoryClientTests: XCTestCase {
    // Test connection and heartbeat
    func testConnection() {
        let configuration = ClientConfiguration(hostName: "localTestHost", wid: UUID().uuidString)
        let client = FaktoryClient(configuration: configuration)
        var result = client.connect()
        XCTAssertEqual(result, FaktoryClient.CommResult.commOk)
        
        XCTAssertEqual(client.heartBeat(), .ok)
        
        result = client.disconnect()
        XCTAssertEqual(result, FaktoryClient.CommResult.commOk)
    }
    
    // Test client functions for job lifecycle:
    // Push, fetch, ack and fail
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
        
        // Fetch back the jobs
        let fJob1 = fetchAndVerifyJob(client: client, job: job2)
        let fJob2 = fetchAndVerifyJob(client: client, job: job1)
        let fJob3 = fetchAndVerifyJob(client: client, job: job3)
        
        // Check an empty fetch
        let noJob = client.fetch(queues: ["critical", "default", "low"])
        XCTAssert(noJob == nil)
        
        // Ack 2 jobs and fail the other
        XCTAssertEqual(client.ack(job: fJob1), .commOk)
        XCTAssertEqual(client.ack(job: fJob2), .commOk)
        XCTAssertEqual(client.fail(job: fJob3, errorMessage: "Generic error", errorType: "runtime", backTrace: ["line1", "line2"]), .commOk)
        
        result = client.disconnect()
        XCTAssertEqual(result, FaktoryClient.CommResult.commOk)
    }
    
    private func fetchAndVerifyJob(client: FaktoryClient, job: FaktoryJob) -> FaktoryJob {
        let resJob = client.fetch(queues: ["critical", "default", "low"])
        XCTAssert(resJob != nil)
        XCTAssertEqual(resJob!.id, job.id)
        XCTAssertEqual(resJob!.type, job.type)
        XCTAssertEqual(resJob!.args, job.args)
        
        return resJob!
    }
    

    // Linux helpers
    static var allTests = [
        ("testConnection", testConnection),
        ("testJobLifeCycle", testJobLifeCycle)
        ]

}
