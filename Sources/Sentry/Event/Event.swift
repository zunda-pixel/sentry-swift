import Foundation

public struct Event: Codable {
  public var eventId: String
  public var sentAt: Date
  public var trace: Trace
  public var sdk: SDK

  public init(
    eventId: String,
    sentAt: Date,
    trace: Trace,
    sdk: SDK
  ) {
    self.eventId = eventId
    self.sentAt = sentAt
    self.trace = trace
    self.sdk = sdk
  }

  private enum CodingKeys: String, CodingKey {
    case sdk
    case sentAt = "sent_at"
    case trace
    case eventId = "event_id"
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.sdk = try container.decode(SDK.self, forKey: .sdk)
    self.sentAt = try Date(
      container.decode(String.self, forKey: .sentAt),
      strategy: .iso8601WithFractionSeconds
    )
    self.trace = try container.decode(Event.Trace.self, forKey: .trace)
    self.eventId = try container.decode(String.self, forKey: .eventId)
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.sdk, forKey: .sdk)
    try container.encode(self.sentAt.formatted(.iso8601WithFractionSeconds), forKey: .sentAt)
    try container.encode(self.trace, forKey: .trace)
    try container.encode(self.eventId, forKey: .eventId)
  }

  public struct Trace: Codable {
    public var traceId: String
    public var publicKey: String
    public var release: String
    public var environment: String

    public init(
      traceId: String,
      publicKey: String,
      release: String,
      environment: String
    ) {
      self.traceId = traceId
      self.publicKey = publicKey
      self.release = release
      self.environment = environment
    }

    private enum CodingKeys: String, CodingKey {
      case traceId = "trace_id"
      case publicKey = "public_key"
      case release
      case environment
    }
  }
}
