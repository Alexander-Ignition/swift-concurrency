#  Swift Concurrency

language | keywords | type
-|-|-
C# | async / await | Task
JS | async / await | Promise
Python | async / await | -
Kotlin | suspend | Job
Swift | async / await | Task

## Setup Xcode project

1. [Download](https://swift.org/download/#snapshots) and install Swift Development Snapshot.
2. Open Xcode’s Preferences, navigate to Components > Toolchains, and select the installed Swift toolchain.
3. Open Project, Build Setting, OTHER_SWIFT_FLAGS and past `-Xfrontend -enable-experimental-concurrency`.

## Links

- [Swift Concurrency Roadmap](https://forums.swift.org/t/swift-concurrency-roadmap/41611)
- [Asynchronous functions](https://forums.swift.org/t/concurrency-asynchronous-functions/41619)
- [Structured concurrency](https://forums.swift.org/t/concurrency-structured-concurrency/41622)
- [Interoperability with Objective-C](https://forums.swift.org/t/concurrency-interoperability-with-objective-c/41616)
- [Actors & actor isolation](https://forums.swift.org/t/concurrency-actors-actor-isolation/41613)
- [Future of Swift-NIO in light of Concurrency Roadmap](https://forums.swift.org/t/future-of-swift-nio-in-light-of-concurrency-roadmap/41633)
