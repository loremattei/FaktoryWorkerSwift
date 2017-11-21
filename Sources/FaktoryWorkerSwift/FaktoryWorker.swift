import Foundation

// MARK: Faktory's Worker 
public class FaktoryWorker {
    // Worker available statuses
    public enum WorkerStatus {
        case stopped, suspended, running
    }
    
    // Faktory client configuration
    public let clientConfiguration: ClientConfiguration
    
    // Queues to pool for fetching
    public var queues: [String]
    
    // The avaiable job executors
    public let jobExecs: [String: JobExec]
    
    // Worker status
    private var wStatus : WorkerStatus
    private var status: WorkerStatus {
        get {
            sem.wait()
            let s = wStatus
            sem.signal()
            return s
        }
        set (newValue) {
            sem.wait()
            wStatus = newValue
            sem.signal()
        }
    }
    
    public var workerStatus : WorkerStatus {
        get {
            return status
        }
    }
    
    // Jobs count
    public let maxConcurrentJobs = 3
    private var wRunningJobs: Int = 0
    private var runningJobs: Int {
        get {
            sem.wait()
            let r = wRunningJobs
            sem.signal()
            return r
        }
        set (newValue) {
            sem.wait()
            wRunningJobs = newValue
            sem.signal()
        }
    }
    
    // Worker's components, threads, etc
    private var client: FaktoryClient?
    private let sem = DispatchSemaphore(value: 1)
    private let clientQueue = DispatchQueue(label: "client")
    private let workerQueue = DispatchQueue(label: "workers", attributes: .concurrent)
    
    // MARK: Initializers
    init(clientConfiguration: ClientConfiguration, queues: [String], jobExecs: [JobExec]) {
        self.clientConfiguration = clientConfiguration
        wStatus = .stopped
        client = nil
        self.queues = queues
        
        // Create the dictionary of executors
        var tmpJobs = [String : JobExec]()
        for j in jobExecs {
            tmpJobs[j.jobType] = j
        }
        
        self.jobExecs = tmpJobs
    }
    
    // MARK: Public Methods
    public func start() -> Bool {
        if (status != .stopped) {
            return false
        }
        
        // Create the client and start it
        self.client = FaktoryClient(configuration: clientConfiguration)
        guard client?.connect() == .commOk else {
            client = nil
            return false
        }
        
        status = .running
        
        // Start the heartbeat
        sendHeartBeat()
        
        // Start the standard job fetching
        clientQueue.async {
            self.fetchJob()
        }
        
        return true
    }
    
    // Suspends the worker.
    // A suspended worker continue to send the heartbeat
    // to the server and terminates the running jobs
    public func suspend() -> Bool {
        if (status == .stopped) {
            return false
        }
        
        status = .suspended
        
        return true
    }
    
    // Resumes the worker.
    public func resume() -> Bool {
        if (status != .suspended) {
            return false
        }
        
        status = .running
        
        return true
    }
    
    public func stop() -> Bool {
        if (status == .stopped) {
            return false
        }
        
        // Signal to stop
        status = .stopped
        
        // Wait the queue to clear
        while (runningJobs > 0) {
            sleep(5)
        }
        
        _ = client?.disconnect()
        client = nil
        
        return true
    }
    
    // MARK: Private methods
    private func sendHeartBeat() {
        clientQueue.asyncAfter(deadline: .now() + .seconds(15)) {
            let res = self.client?.heartBeat()
            print("Heartbeat, with result: \(res ?? .nok)")
            
            switch(res ?? .nok) {
            case .ok:
                // Reschedule, if possible
                if (self.status == .running) {
                    self.sendHeartBeat()
                }
            default:
                // Beat failed.
                DispatchQueue.main.async {
                    _ = self.stop()
                }
            }
        }
    }
    
    private func fetchJob() {
        while (self.runningJobs < self.maxConcurrentJobs) {
            switch (self.status) {
            case .stopped:
                return
            case .suspended:
                sleep(1)
            case .running:
                let newJob = self.client?.fetch(queues: queues)
                if (newJob != nil) {
                    self.runningJobs = self.runningJobs + 1
                    workerQueue.async {
                        self.runJob(newJob!)
                    }
                }
            }
            
            sleep(1)
        }
    }
    
    private func runJob(_ job: FaktoryJob) {
        let wj = JobWrapper(job)
        executeJob(wj)
        terminateJob(wj)
    }
    
    private func executeJob(_ job: JobWrapper) {
        if (!self.jobExecs.keys.contains(job.job.type)) {
            // No registered handler for this job
            job.errorType = "UnknownJobType"
            job.errorMessage = "No registered handler for \(job.job.type) job type"
            job.result = false
            return
        }
        
        // Get the job executor
        let j = self.jobExecs[job.job.type]!
        j.ExecuteJob(job)
    }
    
    private func terminateJob(_ job: JobWrapper) {
        if (job.result ?? false) {
            // Ack the job
            clientQueue.sync {
                _ = self.client?.ack(job: job.job)
            }
        }
        else {
            // Nack the job
            clientQueue.sync {
                _ = self.client?.fail(job: job.job, errorMessage: job.errorMessage ?? "", errorType: job.errorType ?? "", backTrace: job.backTrace ?? [""])
            }
        }
        
        // Decrease the running job count
        self.runningJobs = self.runningJobs - 1
        
        // Fetch the next
        clientQueue.async {
            self.fetchJob()
        }
    }
}
