import Foundation
import Testing

@testable import Sentry

@Suite
struct APITests {
  let client = Client(
    organizationId: ProcessInfo.processInfo.environment["ORGANIZATION_ID"]!,
    projectId: ProcessInfo.processInfo.environment["PROJECT_ID"]!,
    apiToken: ProcessInfo.processInfo.environment["API_TOKEN"]!,
    httpClient: .urlSession(.shared)
  )
}
