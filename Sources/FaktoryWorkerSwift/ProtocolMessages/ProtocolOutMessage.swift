import Foundation

// TODO: Comments!
public class FaktoryOutMessage: Encodable {
    var messageVerb: String?
    
    init(_ verb: String) {
        messageVerb = verb
    }
    
    public func createMessage() -> String {
        if (messageVerb == nil) {
            // TODO: Assert fail!
            return ""
        }
        
        var message = messageVerb!
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(self)
            let jsonString = String(data: jsonData, encoding: .utf8)
            
            message += " " + jsonString!
            message = message + "\r\n"
        } catch {
            return ""
        }
        
        return message
    }
}
