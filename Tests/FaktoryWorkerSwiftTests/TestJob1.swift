import Foundation
import FaktoryWorkerSwift

// Simple test job
public class TestJob1 : JobExec {
    // The job this class can manage
    public var jobType : String {
        get {
            return "stdJob"
        }
        
    }
    
    // Executes the job
    public func ExecuteJob(_ job: JobWrapper) {
        print ("TestJob1: Executing job [\(job.job.id)]")
    }
}
