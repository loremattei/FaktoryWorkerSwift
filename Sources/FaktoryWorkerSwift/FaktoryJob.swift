import Foundation

// MARK: FaktoryJob: Wraps the Job!

public class FaktoryJob {
    // Job ID (UUID)
    public let id : String;
    
    // Job Type
    public let type : String;
    
    // Job custom arguments
    public let args : Array<AnyObject>;
    
    // Default initializer
    init(id: String, type: String, args: Array<AnyObject>) {
        self.id = id;
        self.type = type;
        self.args = args;
    }
}
