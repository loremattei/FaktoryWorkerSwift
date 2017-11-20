import Foundation


// MARK: JobWrapper: Wraps a job when it has to be executed and it stores the result
public class JobWrapper {
    // Job
    public let job : FaktoryJob
    
    // Result
    public var result : Bool?
    
    // Error Message
    public var errorMessage : String?
    
    // Error Type
    public var errorType : String?
    
    // Error backtrace
    public var backTrace : [String]?
    
    // Initializers
    init(_ job: FaktoryJob) {
        self.job = job
        self.result = nil
        self.errorMessage = nil
        self.errorType = nil
        self.backTrace = nil
    }
}
