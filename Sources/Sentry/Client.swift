import Foundation
import HTTPClient
import HTTPTypes
import HTTPTypesFoundation

#if canImport(NetworkFoundation)
  import NetworkFoundation
#endif

public struct Client<HTTPClient: HTTPClientProtocol> {
  public var organizationId: String
  public var projectId: String
  public var apiToken: String
  public var clientName: String = "sentry.cocoa/8.52.1"
  public var version: Int = 7
  public var httpClient: HTTPClient

  public var baseUrl: URL {
    URL(string: "https://o\(organizationId).ingest.us.sentry.io/api/\(projectId)")!
  }

  public init(
    organizationId: String,
    projectId: String,
    apiToken: String,
    httpClient: HTTPClient
  ) {
    self.organizationId = organizationId
    self.projectId = projectId
    self.apiToken = apiToken
    self.httpClient = httpClient
  }

  public init?(
    dns: URL,
    httpClient: HTTPClient
  ) {
    guard var organizationId = dns.host()?.components(separatedBy: ".").first,
      let apiToken = dns.user()
    else {
      return nil
    }

    organizationId.removeFirst()  // remove "o" at first

    self.init(
      organizationId: organizationId,
      projectId: dns.lastPathComponent,
      apiToken: apiToken,
      httpClient: httpClient
    )
  }
}

extension Client: Sendable where HTTPClient: Sendable {}
