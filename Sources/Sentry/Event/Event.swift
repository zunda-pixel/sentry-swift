import Foundation

struct Event: Codable {
  var eventId: String
  var sentAt: Date
  var trace: Trace
  var sdk: SDK

  enum CodingKeys: String, CodingKey {
    case sdk
    case sentAt = "sent_at"
    case trace
    case eventId = "event_id"
  }

  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.sdk = try container.decode(SDK.self, forKey: .sdk)
    self.sentAt = try Date(
      container.decode(String.self, forKey: .sentAt),
      strategy: .iso8601WithFractionSeconds
    )
    self.trace = try container.decode(Event.Trace.self, forKey: .trace)
    self.eventId = try container.decode(String.self, forKey: .eventId)
  }

  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.sdk, forKey: .sdk)
    try container.encode(self.sentAt.formatted(.iso8601WithFractionSeconds), forKey: .sentAt)
    try container.encode(self.trace, forKey: .trace)
    try container.encode(self.eventId, forKey: .eventId)
  }

  struct Trace: Codable {
    var traceId: String
    var publicKey: String
    var release: String
    var environment: String

    enum CodingKeys: String, CodingKey {
      case traceId = "trace_id"
      case publicKey = "public_key"
      case release
      case environment
    }
  }
}

struct SDK: Codable {
  var name: String
  var version: String
  var packages: [Package]
  var features: [String]
  var integrations: [String]

  struct Package: Codable {
    var name: String
    var version: String
  }
}
