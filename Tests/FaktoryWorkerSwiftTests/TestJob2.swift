import Foundation
import FaktoryWorkerSwift

// Simple test job
public class TestJob2 : JobExec {
    // The job this class can manage
    public var jobType : String {
        get {
            return "anotherJob"
        }
        
    }
    
    // Executes the job
    public func ExecuteJob(_ job: JobWrapper) {
        print ("TestJob2: Executing job [\(job.job.id)]")
    }
}
