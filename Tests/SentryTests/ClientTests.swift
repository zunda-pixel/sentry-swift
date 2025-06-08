import Foundation
import Testing

@testable import Sentry

@Suite
struct ClientTests {
  @Test
  func initializeWithDNS() throws {
    let dns = URL(
      string:
        "https://111_API_TOKEN_111@o222_ORGANIZATION_ID_222.ingest.us.sentry.io/333_PROJECT_ID_333")!
    let client = try #require(
      Client(
        dns: dns,
        httpClient: .urlSession(.shared)
      )
    )

    #expect(client.organizationId == "222_ORGANIZATION_ID_222")
    #expect(client.projectId == "333_PROJECT_ID_333")
    #expect(client.apiToken == "111_API_TOKEN_111")
  }
}
