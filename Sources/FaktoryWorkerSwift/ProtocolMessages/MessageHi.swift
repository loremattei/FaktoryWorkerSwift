import Foundation

// MARK: Faktory's protocol Hi Message
public final class MessageHi : FaktoryInMessage {
    var v : Int = -1
    var s : String? = nil
    var i : Int? = nil
    
    init(_ messageString: String) throws {
        do {
            try super.init(messageVerb: "HI", message: messageString)
            try parseMessage()
        } catch {
            // TODO:
            throw "Another error"
        }
    }
    
    private func parseMessage() throws {
        let mData = messageData!
        
        if (!mData.keys.contains("v")) {
            // TODO:
            throw "Bad formatted message"
        }
        
        self.v = mData["v"] as! Int
        
        if (mData.keys.contains("s")) {
            s = mData["s"] as! String?
        }
        
        if (mData.keys.contains("i")) {
            i = mData["i"] as! Int?
        }
    }
    
}

