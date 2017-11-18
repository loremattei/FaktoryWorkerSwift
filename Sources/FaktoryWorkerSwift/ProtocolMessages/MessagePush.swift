import Foundation

// MARK: Manages the Faktory's PUSH protocol message
public class MessagePush : FaktoryOutMessage {
    // Initializer
    init(_ job: FaktoryJob)  {
        super.init("PUSH", body: job.toJsonString()!)
    }
}

