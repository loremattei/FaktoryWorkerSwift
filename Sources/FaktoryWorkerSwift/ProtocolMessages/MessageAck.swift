import Foundation

// MARK: Manages the Faktory's ACK protocol message
public class MessageAck : FaktoryOutMessage {
    // Initializer
    init(_ job: FaktoryJob)  {
        super.init("ACK", body: job.idToJsonString()!)
    }
}
