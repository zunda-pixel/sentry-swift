import Foundation

struct LogEvent<
  MechanismData: Codable & Sendable & Hashable,
  MechanismMeta: Codable & Sendable & Hashable
>: Codable {
  var eventId: String
  var environment: String
  var level: String
  var platform: String
  var timestamp: Date
  var release: String
  var dist: String
  var user: User
  var extra: Extra
  var exception: Exceptions
  var tags: Tags
  var breadcrumbs: [Breadcrumb]
  var threads: Threads
  var contexts: Contexts
  var sdk: SDK
  var debugMeta: DebugMeta

  enum CodingKeys: String, CodingKey {
    case eventId = "event_id"
    case environment
    case level
    case platform
    case timestamp
    case release
    case dist
    case user
    case extra
    case exception
    case tags
    case breadcrumbs
    case threads
    case contexts
    case sdk
    case debugMeta = "debug_meta"
  }

  struct User: Codable, Hashable, Sendable {
    var id: UUID
  }

  struct Extra: Codable, Hashable, Sendable {

  }

  struct Exceptions: Codable, Hashable, Sendable {
    var values: [Exception]
  }

  struct Exception: Codable, Hashable, Sendable {
    var value: String
    var type: String
    var mechanism: Mechanism

    struct Mechanism: Codable, Hashable, Sendable {
      var data: MechanismData
      var meta: MechanismMeta
      var type: String
      var description: String
    }
  }

  struct Tags: Codable, Hashable, Sendable {

  }

  struct Breadcrumb: Codable, Hashable, Sendable {
    var timestamp: Date
    var level: String
    var type: String
    var category: String
    var message: String?
    var data: [String: String]?

    enum CodingKeys: CodingKey {
      case message
      case timestamp
      case level
      case type
      case category
      case data
    }

    init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.message = try container.decodeIfPresent(String.self, forKey: .message)
      self.timestamp = try Date(
        container.decode(String.self, forKey: .timestamp),
        strategy: .iso8601WithFractionSeconds
      )
      self.level = try container.decode(String.self, forKey: .level)
      self.type = try container.decode(String.self, forKey: .type)
      self.category = try container.decode(String.self, forKey: .category)
      self.data = try container.decodeIfPresent([String: String].self, forKey: .data)
    }

    func encode(to encoder: any Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(
        self.timestamp.formatted(.iso8601WithFractionSeconds),
        forKey: .timestamp
      )
      try container.encode(self.level, forKey: .level)
      try container.encode(self.type, forKey: .type)
      try container.encode(self.category, forKey: .category)
      try container.encodeIfPresent(self.message, forKey: .message)
      try container.encodeIfPresent(self.data, forKey: .data)
    }
  }

  struct Threads: Codable, Hashable, Sendable {
    var values: [Thread]

    struct Thread: Codable, Hashable, Sendable {
      var id: Int
      var current: Bool
      var crashed: Bool
      var main: Bool
      var name: String?
      var stasktrace: Stacktrace?

      struct Stacktrace: Codable, Hashable, Sendable {
        var frames: [Frame]

        struct Frame: Codable, Hashable, Sendable {
          var package: String
          var symbolAddress: String
          var imageAddress: String
          var function: String
          var instructionAddres: String
          var inApp: Bool

          enum CodingKeys: String, CodingKey {
            case package
            case symbolAddress = "symbol_addr"
            case imageAddress = "image_addr"
            case function
            case instructionAddres = "instruction_addr"
            case inApp = "in_app"
          }
        }
      }
    }
  }

  struct Contexts: Codable, Hashable, Sendable {
    var app: App
    var os: OS
    var device: Device
    var trace: Trace
    var culture: Culture

    struct App: Codable, Hashable, Sendable {
      var appName: String
      var buildType: String
      var appVersion: String
      var appIdentifier: String
      var appStartTime: Date
      var appId: String
      var deviceAppHash: String
      var inForeground: Bool
      var appBuild: String
      var appMemory: Int
      var viewNames: [String]

      enum CodingKeys: String, CodingKey {
        case appName = "app_name"
        case buildType = "build_type"
        case appVersion = "app_version"
        case appIdentifier = "app_identifier"
        case appStartTime = "app_start_time"
        case appId = "app_id"
        case deviceAppHash = "device_app_hash"
        case appBuild = "app_build"
        case inForeground = "in_foreground"
        case appMemory = "app_memory"
        case viewNames = "view_names"
      }

      init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.appName = try container.decode(String.self, forKey: .appName)
        self.buildType = try container.decode(String.self, forKey: .buildType)
        self.appVersion = try container.decode(String.self, forKey: .appVersion)
        self.appIdentifier = try container.decode(String.self, forKey: .appIdentifier)
        self.appStartTime = try Date(
          container.decode(String.self, forKey: .appStartTime),
          strategy: .iso8601
        )
        self.appId = try container.decode(String.self, forKey: .appId)
        self.deviceAppHash = try container.decode(String.self, forKey: .deviceAppHash)
        self.appBuild = try container.decode(String.self, forKey: .appBuild)
        self.inForeground = try container.decode(Bool.self, forKey: .inForeground)
        self.appMemory = try container.decode(Int.self, forKey: .appMemory)
        self.viewNames = try container.decode([String].self, forKey: .viewNames)
      }

      func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.appName, forKey: .appName)
        try container.encode(self.buildType, forKey: .buildType)
        try container.encode(self.appVersion, forKey: .appVersion)
        try container.encode(self.appIdentifier, forKey: .appIdentifier)
        try container.encode(self.appStartTime.formatted(.iso8601), forKey: .appStartTime)
        try container.encode(self.appId, forKey: .appId)
        try container.encode(self.deviceAppHash, forKey: .deviceAppHash)
        try container.encode(self.appBuild, forKey: .appBuild)
        try container.encode(self.inForeground, forKey: .inForeground)
        try container.encode(self.appMemory, forKey: .appMemory)
        try container.encode(self.viewNames, forKey: .viewNames)
      }
    }

    struct OS: Codable, Hashable, Sendable {
      var name: String
      var version: String
      var rooted: Bool
      var kernelVersion: String
      var build: String

      enum CodingKeys: String, CodingKey {
        case name
        case version
        case rooted
        case kernelVersion = "kernel_version"
        case build
      }
    }

    struct Device: Codable, Hashable, Sendable {
      var model: String
      var modelId: String
      var family: String
      var arch: String
      var orientation: String
      var thermalState: String
      var simulator: Bool
      var batteryLevel: Int
      var locale: String
      var charging: Bool
      var processorCount: Int
      var memorySize: Int
      var usableMemory: Int
      var freeMemory: Int

      enum CodingKeys: String, CodingKey {
        case model
        case modelId = "model_id"
        case family
        case arch
        case orientation
        case thermalState = "thermal_state"
        case simulator
        case batteryLevel = "battery_level"
        case locale
        case charging
        case processorCount = "processor_count"
        case memorySize = "memory_size"
        case usableMemory = "usable_memory"
        case freeMemory = "free_memory"
      }
    }

    struct Trace: Codable, Hashable, Sendable {
      var spanId: String
      var traceId: String

      enum CodingKeys: String, CodingKey {
        case spanId = "span_id"
        case traceId = "trace_id"
      }
    }

    struct Culture: Codable, Hashable, Sendable {
      var locale: String
      var timezone: String
      var displayName: String
      var calendar: String
      var is24HourFormat: Bool

      enum CodingKeys: String, CodingKey {
        case locale
        case timezone
        case displayName = "display_name"
        case calendar
        case is24HourFormat = "is_24_hour_format"
      }
    }
  }

  struct DebugMeta: Codable, Hashable, Sendable {
    var images: [Image]

    struct Image: Codable, Hashable, Sendable {
      var debugId: String
      var imageAddress: String
      var type: String
      var imageSize: Int
      var codeFile: String

      enum CodingKeys: String, CodingKey {
        case debugId = "debug_id"
        case imageAddress = "image_addr"
        case type
        case imageSize = "image_size"
        case codeFile = "code_file"
      }
    }
  }
}
