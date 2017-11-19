import Foundation

// MARK: Manages the Faktory's FETCH protocol message
public class MessageFetch : FaktoryOutMessage {
    // Initializer
    init(_ queues: [String])  {
        var data = ""
        for q in queues {
            data += "\(q) "
        }
        
        super.init("FETCH", body: data)
    }
}

