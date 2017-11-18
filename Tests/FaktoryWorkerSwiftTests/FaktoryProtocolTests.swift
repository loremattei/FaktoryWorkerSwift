import XCTest
@testable import FaktoryWorkerSwift

class FaktoryProtocolTests: XCTestCase {
    
    // Tests that a received message is properly parsed and understood
    func testVerbHandling() {
        let message = "HI {\"simple\" : \"json\"}"
        
        // Verify that an unproper message is detected
        let faktoryMessage = try? FaktoryInMessage(messageVerb: "HH", message: message)
        XCTAssert(faktoryMessage == nil)
        
        // Verify that a proper message is parsed
        let faktoryMessage2 = try? FaktoryInMessage(messageVerb: "HI", message: message)
        XCTAssert(faktoryMessage2 != nil)
        XCTAssert(faktoryMessage2!.messageData != nil)
        let data  = faktoryMessage2!.messageData!["simple"] as! String
        XCTAssertEqual(data, "json")
    }
    
    // Tests the parser of the HI message
    func testHiMessageParser() {
        // TODO: Add checks for fail conditions!
        // Verifies the simple HI
        let message = "HI {\"v\" : 2}"
        let hiMessage = try? MessageHi(message)
        XCTAssert(hiMessage != nil)
        XCTAssertEqual(hiMessage!.v, 2)
        
        // Verifies the complete HI (with password)
        let message2 = "HI {\"v\":2,\"s\":\"123456789abc\",\"i\":1735}"
        let hiMessage2 = try? MessageHi(message2)
        XCTAssert(hiMessage2 != nil)
        XCTAssertEqual(hiMessage2!.v, 2)
        XCTAssertEqual(hiMessage2!.s, "123456789abc")
        XCTAssertEqual(hiMessage2!.i, 1735)
    }
    
    // Tests the generator of the HELLO message
    func testHelloMessageGenerator() {
        let configuration = ClientConfiguration(hostName: "localHost", wid: UUID().uuidString)
        
        // Verifies HELLO generation with no password request
        let hiMessage = try? MessageHi("HI {\"v\" : 2}")
        let message = try? MessageHello(configuration: configuration, hiMessage: hiMessage!)
        let messageString = message!.createMessage()
        XCTAssertEqual(messageString, "HELLO {\"pid\":\(message!.pid),\"hostName\":\"localHost\",\"v\":2,\"wid\":\"\(message!.wid)\"}\r\n")
        
        // TODO: Create test for password case
    }

    // Linux helpers
    static var allTests = [
        ("testVerbHandling", testVerbHandling),
        ("testHiMessageParser", testHiMessageParser),
        ("testHelloMessageGenerator", testHelloMessageGenerator),
        ]
}
