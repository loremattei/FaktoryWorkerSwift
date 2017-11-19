import Foundation

// MARK: Manages the Faktory's FAIL protocol message
public class MessageFail : FaktoryOutMessage {
    // Initializer
    init(job: FaktoryJob, type: String, message: String, backTrace: [String])  {
        let data : [String : Any] = ["jid": job.id, "errtype": type, "message": message, "backtrace": backTrace]
        
        var messageBody : String
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data)
            messageBody = String(data: jsonData, encoding: .utf8)! as String
        } catch {
            messageBody = ""
        }
        super.init("FAIL", body: messageBody)
    }
}

