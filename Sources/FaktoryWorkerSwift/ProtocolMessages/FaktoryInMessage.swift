import Foundation

// MARK: Base class for Faktory's protocol messages
public class FaktoryInMessage {
    // The verb that the class handles
    let messageVerb: String
    
    // Data payload
    var messageData: [String: Any]? = nil
    
    // Initializer
    init(messageVerb: String, message: String?) throws {
        self.messageVerb = messageVerb
        
        if ((message != nil) && (!checkMessage(message!))) {
            // TODO: 
            throw "Bad message error"
        }
    }
    
    // Checks that the message is well formatted, that the verb
    // matches the one handled by the class and
    // finally it parses the JSON data
    private func checkMessage(_ message: String) -> Bool {
        if (message.count == 0) {
            return false
        }
        
        let index = message.index(of: "{") ?? message.endIndex
        if (message[..<index].trimmingCharacters(in: .whitespaces) != messageVerb) {
            return false
        }
        
        let messageBody = String(message[index..<message.endIndex])
        messageData = Parse(messageBody)

        return true
    }
    
    // JSON parser
    private func Parse(_ messageBody: String) -> [String: Any]? {
        if let data = messageBody.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
