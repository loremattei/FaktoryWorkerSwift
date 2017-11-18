import Foundation

// MARK: Manages the Faktory's HELLO protocol message
public class MessageHello : FaktoryOutMessage {
    // Client host name
    let hostName : String
    
    // Client PID
    let pid : pid_t
    
    // Client WID
    let wid: String
    
    // Custom labels
    let labels: [String]?
    
    // Password hash
    let passwordHash: String?
    
    // Protocol version
    let v = 2
    
    
    // Initializer
    init(configuration: ClientConfiguration, hiMessage: MessageHi) throws {
        hostName = configuration.hostName
        wid = configuration.wid
        labels = configuration.labels
        passwordHash = MessageHello.evaluatePasswordHash(hiMessage)
        pid = getpid()
        super.init("HELLO")
    }
    
    // Calculate password hash
    private static func evaluatePasswordHash(_ hiMessage: MessageHi) -> String? {
        if (hiMessage.s == nil) {
            return nil
        }
        
        // TODO:
        return ""
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(v, forKey: .version)
        try container.encode(hostName, forKey: .hostName)
        try container.encode(wid, forKey: .wid)
        try container.encode(pid, forKey: .pid)
        
        if (labels != nil) {
            try container.encode(labels, forKey: .labels)
        }
        
        if (passwordHash != nil) {
            try container.encode(wid, forKey: .passwordHash)
        }
    }
    
    //Set JSON key values for fields in our job
    private enum CodingKeys: String, CodingKey {
        case hostName
        case wid
        case labels
        case version = "v"
        case passwordHash = "pwdhash"
        case pid
    }
}
