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
    
    //Set JSON key values for fields in our job
    private enum CodingKeys: String, CodingKey {
        case id = "jid"
        case type = "jobtype"
        case args
        case queue
    }
}
