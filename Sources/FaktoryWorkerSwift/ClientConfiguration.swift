import Foundation

// MARK: Client configuration data
public struct ClientConfiguration {
    // Server address
    public var serverAddress : String = "127.0.0.1"
    
    // Server port
    public var port : Int = 7419
    
    // Client host name
    public var hostName : String
    
    // Client WID
    public var wid : String
    
    public var labels: [String]?
    
    // Initializers
    init(hostName: String) {
        self.hostName = hostName
        wid = UUID().uuidString
    }
    
    init(hostName: String, wid: String) {
        self.hostName = hostName
        self.wid = wid
    }
}
