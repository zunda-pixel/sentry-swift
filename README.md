# sentry-swift

Sentry API for Client written in Swift

```swift
import Foundation
import Sentry

let dns = URL(string: "https://111_API_TOKEN_111@o222_ORGANIZATION_ID_222.ingest.us.sentry.io/333_PROJECT_ID_333")!
let client = Client(
  dns: dns,
  httpClient: .urlSession(.shared)
)!

let event: Event
let log: LogEvent<Empty, Empty>
let error: ErrorEvent

try await client.postLog(
  event: event,
  log: log,
  error: error
)
```
