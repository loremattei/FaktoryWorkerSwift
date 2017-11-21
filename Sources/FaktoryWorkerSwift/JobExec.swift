import Foundation

// MARK: An object that can execute a certain type of job
public protocol JobExec {
    // The job this class can manage
    var jobType : String { get }
    
    // Executes the job
    // Notes:
    // A. multiple async calls to this method
    // can be made if FaktoryWorker.maxConcurrentJobs value is
    // greater than 1.
    // B. The method shall set the job result and, when required, the error info
    func ExecuteJob(_ job: JobWrapper) 
}
