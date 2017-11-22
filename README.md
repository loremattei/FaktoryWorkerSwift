# FaktoryWorkerSwift

This repository provides a [Faktory](https://github.com/contribsys/faktory) worker process for Swift apps.  
The worker fetches background jobs from the server and processes them.

# Installation

You need [Faktory](https://github.com/contribsys/faktory) installed first.

Then, you can install via Swift Package Manager.

Add to your `Package.swift` dependencies:

```swift
import PackageDescription

let package = Package(
    // ... your project details
    dependencies: [
        // As a required dependency
        .Package(url: "ssh://git@github.com/loremattei/FaktoryWorkerSwift.git", from: "0.1.0")
    ],
    testDependencies: [
        // As a test dependency
        .Package(url: "ssh://git@github.com/loremattei/FaktoryWorkerSwift", from: "0.1.0")
    ]
)
```

# Usage

Basic steps:

1. Push a job to faktory server
2. Register your jobs and their associated functions
3. Start working

#### Pushing Jobs:

A Faktory job is a payload of keys and values. Currently, The FaktoryJob implements the basic properties only.

```swift
import FaktoryWorkerSwift

// Create the client
let configuration = ClientConfiguration(hostName: "localTestHost", wid: UUID().uuidString)
let client = FaktoryClient(configuration: configuration)
var result = client.connect()

// Push a job
let job1 = FaktoryJob(id: UUID().uuidString, type: "stdJob", args: ["1", "2", "3"])
client.push(job: job1)

```

#### Processing Jobs:

A job shall implement the JobExec protocol. Basically, it:
- declares its type to allow the worker to route the jobs
- exposes a method to be called in order to execute the job.

Jobs are registered at worker init.

The worker can be started, suspended, resumed and stopped.
Once started, the worker loops on an async queue and fetches and executing the jobs.
When suspended, the worker doesn't fetch any other job, but terminates the running ones and maintains the connection to the server.
When resumed, the worker restarts to fetch jobs.
When stopped, it waits for the current jobs to terminate and exits. 

```swift
import FaktoryWorkerSwift

// Create the worker
let configuration = ClientConfiguration(hostName: "localTestHost", wid: UUID().uuidString)
let worker = FaktoryWorker(clientConfiguration: configuration, queues: ["critical", "default", "low"], jobExecs: [TestJob1(), TestJob2()])

// Start the work loop
worker.start()
```

# TODO List

- Better error handling
- Password SHA encoding
- Job optional field handling
- Worker quite and terminate implementation
- Complete integration tests suite.

# Author

Lorenzo Mattei, @loremattei

