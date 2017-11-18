import Foundation

// MARK: Faktory's protocol standard out message
public class FaktoryOutMessage: Encodable {
    var messageVerb: String?
    var messageBody: String?
    
    // MARK: Initializers
    init(_ verb: String) {
        messageVerb = verb
        messageBody = nil
    }
    
    init (_ verb: String, body: String) {
        messageVerb = verb
        messageBody = body
    }
    
    // MARK: Public methods
    // Creates the output message string
    public func createMessage() -> String {
        if (messageVerb == nil) {
            // TODO: Assert fail!
            return ""
        }
        
        var message = messageVerb!
        if (messageBody == nil) {
            messageBody = createBody()
        }
        
        message += " " + messageBody!
        message = message + "\r\n"
        
        return message
    }
    
    // MARK: Private methods
    private func createBody() -> String {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(self)
            let jsonString = String(data: jsonData, encoding: .utf8)
            
            return jsonString!
        } catch {
            return ""
        }
    }
}
