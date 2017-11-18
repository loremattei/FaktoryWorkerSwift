# FaktoryWorkerSwift

This repository provides a [Faktory](https://github.com/contribsys/faktory) worker process for Swift apps.  
The worker fetches background jobs from the server and processes them.

Really WIP at the moment.

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

Coming soon...

# Author

Lorenzo Mattei, @loremattei

