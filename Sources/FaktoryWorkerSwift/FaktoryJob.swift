import Foundation

// MARK: FaktoryJob: Wraps the Job!

public class FaktoryJob : Codable {
    // Job ID (UUID)
    public let id : String
    
    // Job Type
    public let type : String
    
    // Job arguments
    public let args : [String]
    
    // The queue the job refers to
    public var queue : String = "default"
    
    // Initializers
    init(id: String, type: String, args: [String]) {
        self.id = id
        self.type = type
        self.args = args
    }
    
    init(id: String, type: String, args: [String], queue: String) {
        self.id = id
        self.type = type
        self.args = args
        self.queue = queue
    }
    
    init?(json: [String: Any]) {
        guard let tmpId = json["jid"] as? String,
              let tmpType = json["jobtype"] as? String,
              let tmpArgs = json["args"] as? [String],
              let tmpQueue = json["queue"] as? String else {
            return nil
        }
        
        id = tmpId
        type = tmpType
        args = tmpArgs
        queue = tmpQueue
    }

    
    // Encodes the job to a JSON string
    public func toJsonString() -> String? {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(self)
            let jsonString = String(data: jsonData, encoding: .utf8)
            
            return jsonString
        }
        catch {
            return nil
        }
    }
    
    public func idToJsonString() -> String? {
        let res = String("{\"jid\":\"\(self.id)\"}")
        return res
    }
    
    //Set JSON key values for fields in our job
    private enum CodingKeys: String, CodingKey {
        case id = "jid"
        case type = "jobtype"
        case args
        case queue
    }
}
