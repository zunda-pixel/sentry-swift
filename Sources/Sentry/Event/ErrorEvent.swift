import Foundation

struct ErrorEvent: Codable, Hashable, Sendable {
  var errors: Int
  var status: String
  var started: Date
  var did: UUID
  var duration: TimeInterval
  var sid: UUID
  var attributes: Attributes
  var timestamp: Date
  var sequence: Int
  
  struct Attributes: Codable, Hashable, Sendable {
    var release: String
    var environment: String
  }
  
  enum CodingKeys: String, CodingKey {
    case errors
    case status
    case started
    case did
    case duration
    case sid
    case attributes = "attrs"
    case timestamp
    case sequence = "seq"
  }
  
  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.errors = try container.decode(Int.self, forKey: .errors)
    self.status = try container.decode(String.self, forKey: .status)
    self.started = try Date(container.decode(String.self, forKey: .started), strategy: .iso8601WithFractionSeconds)
    self.did = try container.decode(UUID.self, forKey: .did)
    self.duration = try container.decode(TimeInterval.self, forKey: .duration)
    self.sid = try container.decode(UUID.self, forKey: .sid)
    self.attributes = try container.decode(ErrorEvent.Attributes.self, forKey: .attributes)
    self.timestamp = try Date(container.decode(String.self, forKey: .timestamp), strategy: .iso8601WithFractionSeconds)
    self.sequence = try container.decode(Int.self, forKey: .sequence)
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.errors, forKey: .errors)
    try container.encode(self.status, forKey: .status)
    try container.encode(self.started.formatted(.iso8601WithFractionSeconds), forKey: .started)
    try container.encode(self.did, forKey: .did)
    try container.encode(self.duration, forKey: .duration)
    try container.encode(self.sid, forKey: .sid)
    try container.encode(self.attributes, forKey: .attributes)
    try container.encode(self.timestamp.formatted(.iso8601WithFractionSeconds), forKey: .timestamp)
    try container.encode(self.sequence, forKey: .sequence)
  }
}
