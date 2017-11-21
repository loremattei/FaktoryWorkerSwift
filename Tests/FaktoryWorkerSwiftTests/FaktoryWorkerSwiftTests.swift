import XCTest
@testable import FaktoryWorkerSwift

// TODO: Here we need far more integration tests
class FaktoryWorkerSwiftTests: XCTestCase {
    
    // Test worker basic functions
    func testBasicWorker() {
        // Configure
        let configuration = ClientConfiguration(hostName: "localTestHost", wid: UUID().uuidString)
        
        // Push some jobs
        let client = FaktoryClient(configuration: configuration)
        var result = client.connect()
        XCTAssertEqual(result, FaktoryClient.CommResult.commOk)
        
        // Create some jobs and push them
        let job1 = FaktoryJob(id: UUID().uuidString, type: "stdJob", args: ["1", "2", "OK"])
        let job2 = FaktoryJob(id: UUID().uuidString, type: "stdJob", args: ["1", "2", "OK"], queue: "critical")
        let job3 = FaktoryJob(id: UUID().uuidString, type: "stdJob", args: ["1", "2", "FAIL"])
        let job4 = FaktoryJob(id: UUID().uuidString, type: "anotherJob", args: ["1", "2", "OK"])
        let job5 = FaktoryJob(id: UUID().uuidString, type: "anotherJob", args: ["1", "2", "OK"])
        
        XCTAssertEqual(client.push(job: job1), .commOk)
        XCTAssertEqual(client.push(job: job2), .commOk)
        XCTAssertEqual(client.push(job: job3), .commOk)
        XCTAssertEqual(client.push(job: job4), .commOk)
        XCTAssertEqual(client.push(job: job5), .commOk)
        
        result = client.disconnect()
        XCTAssertEqual(result, FaktoryClient.CommResult.commOk)
        
        // Start the worker
        let worker = FaktoryWorker(clientConfiguration: configuration, queues: ["critical", "default", "low"], jobExecs: [TestJob1(), TestJob2()])
        
        XCTAssertEqual(worker.start(), true)
        XCTAssertEqual(worker.workerStatus, FaktoryWorker.WorkerStatus.running)

        sleep(5)
        
        // Stop should wait for the jobs to terminate
        XCTAssertEqual(worker.stop(), true)
        XCTAssertEqual(worker.workerStatus, FaktoryWorker.WorkerStatus.stopped)
        
    }
    
    
    // Linux helpers
    static var allTests = [
        ("testBasicWorker", testBasicWorker),
        ]
    
}
