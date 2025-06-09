import Foundation

public struct LogEvent<
  MechanismData: Codable & Sendable & Hashable,
  MechanismMeta: Codable & Sendable & Hashable
>: Codable {
  public var eventId: String
  public var environment: String
  public var level: String
  public var platform: String
  public var timestamp: Date
  public var release: String
  public var dist: String
  public var user: User
  public var extra: Extra
  public var exception: Exceptions
  public var tags: Tags
  public var breadcrumbs: [Breadcrumb]
  public var threads: Threads
  public var contexts: Contexts
  public var sdk: SDK
  public var debugMeta: DebugMeta

  public init(
    eventId: String,
    environment: String,
    level: String,
    platform: String,
    timestamp: Date,
    release: String,
    dist: String,
    user: User,
    extra: Extra,
    exception: Exceptions,
    tags: Tags,
    breadcrumbs: [Breadcrumb],
    threads: Threads,
    contexts: Contexts,
    sdk: SDK,
    debugMeta: DebugMeta
  ) {
    self.eventId = eventId
    self.environment = environment
    self.level = level
    self.platform = platform
    self.timestamp = timestamp
    self.release = release
    self.dist = dist
    self.user = user
    self.extra = extra
    self.exception = exception
    self.tags = tags
    self.breadcrumbs = breadcrumbs
    self.threads = threads
    self.contexts = contexts
    self.sdk = sdk
    self.debugMeta = debugMeta
  }

  private enum CodingKeys: String, CodingKey {
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

  public struct User: Codable, Hashable, Sendable {
    public var id: UUID

    public init(id: UUID) {
      self.id = id
    }
  }

  public struct Extra: Codable, Hashable, Sendable {
    public init() {}
  }

  public struct Exceptions: Codable, Hashable, Sendable {
    public var values: [Exception]

    public init(values: [Exception]) {
      self.values = values
    }
  }

  public struct Exception: Codable, Hashable, Sendable {
    public var value: String
    public var type: String
    public var mechanism: Mechanism

    public init(
      value: String,
      type: String,
      mechanism: Mechanism
    ) {
      self.value = value
      self.type = type
      self.mechanism = mechanism
    }

    public struct Mechanism: Codable, Hashable, Sendable {
      public var data: MechanismData
      public var meta: MechanismMeta
      public var type: String
      public var description: String

      public init(
        data: MechanismData,
        meta: MechanismMeta,
        type: String,
        description: String
      ) {
        self.data = data
        self.meta = meta
        self.type = type
        self.description = description
      }
    }
  }

  public struct Tags: Codable, Hashable, Sendable {
    public init() {}
  }

  public struct Breadcrumb: Codable, Hashable, Sendable {
    public var timestamp: Date
    public var level: String
    public var type: String
    public var category: String
    public var message: String?
    public var data: [String: String]?

    public init(
      timestamp: Date,
      level: String,
      type: String,
      category: String,
      message: String? = nil,
      data: [String: String]? = nil
    ) {
      self.timestamp = timestamp
      self.level = level
      self.type = type
      self.category = category
      self.message = message
      self.data = data
    }

    private enum CodingKeys: CodingKey {
      case message
      case timestamp
      case level
      case type
      case category
      case data
    }

    public init(from decoder: any Decoder) throws {
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

    public func encode(to encoder: any Encoder) throws {
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

  public struct Threads: Codable, Hashable, Sendable {
    public var values: [Thread]

    public init(values: [Thread]) {
      self.values = values
    }
  }

  public struct Thread: Codable, Hashable, Sendable {
    public var id: Int
    public var current: Bool
    public var crashed: Bool
    public var main: Bool
    public var name: String?
    public var stasktrace: Stacktrace?

    public init(
      id: Int,
      current: Bool,
      crashed: Bool,
      main: Bool,
      name: String? = nil,
      stasktrace: Stacktrace? = nil
    ) {
      self.id = id
      self.current = current
      self.crashed = crashed
      self.main = main
      self.name = name
      self.stasktrace = stasktrace
    }

    public struct Stacktrace: Codable, Hashable, Sendable {
      public var frames: [Frame]

      public init(frames: [Frame]) {
        self.frames = frames
      }

      public struct Frame: Codable, Hashable, Sendable {
        public var package: String
        public var symbolAddress: String
        public var imageAddress: String
        public var function: String
        public var instructionAddres: String
        public var inApp: Bool

        public init(
          package: String,
          symbolAddress: String,
          imageAddress: String,
          function: String,
          instructionAddres: String,
          inApp: Bool
        ) {
          self.package = package
          self.symbolAddress = symbolAddress
          self.imageAddress = imageAddress
          self.function = function
          self.instructionAddres = instructionAddres
          self.inApp = inApp
        }

        private enum CodingKeys: String, CodingKey {
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

  public struct Contexts: Codable, Hashable, Sendable {
    public var app: App
    public var os: OS
    public var device: Device
    public var trace: Trace
    public var culture: Culture

    public init(
      app: App,
      os: OS,
      device: Device,
      trace: Trace,
      culture: Culture
    ) {
      self.app = app
      self.os = os
      self.device = device
      self.trace = trace
      self.culture = culture
    }

    public struct App: Codable, Hashable, Sendable {
      public var appName: String
      public var buildType: String
      public var appVersion: String
      public var appIdentifier: String
      public var appStartTime: Date
      public var appId: String
      public var deviceAppHash: String
      public var inForeground: Bool
      public var appBuild: String
      public var appMemory: Int
      public var viewNames: [String]

      public init(
        appName: String,
        buildType: String,
        appVersion: String,
        appIdentifier: String,
        appStartTime: Date,
        appId: String,
        deviceAppHash: String,
        inForeground: Bool,
        appBuild: String,
        appMemory: Int,
        viewNames: [String]
      ) {
        self.appName = appName
        self.buildType = buildType
        self.appVersion = appVersion
        self.appIdentifier = appIdentifier
        self.appStartTime = appStartTime
        self.appId = appId
        self.deviceAppHash = deviceAppHash
        self.inForeground = inForeground
        self.appBuild = appBuild
        self.appMemory = appMemory
        self.viewNames = viewNames
      }

      private enum CodingKeys: String, CodingKey {
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

      public init(from decoder: any Decoder) throws {
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

      public func encode(to encoder: any Encoder) throws {
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

    public struct OS: Codable, Hashable, Sendable {
      public var name: String
      public var version: String
      public var rooted: Bool
      public var kernelVersion: String
      public var build: String

      public init(
        name: String,
        version: String,
        rooted: Bool,
        kernelVersion: String,
        build: String
      ) {
        self.name = name
        self.version = version
        self.rooted = rooted
        self.kernelVersion = kernelVersion
        self.build = build
      }

      private enum CodingKeys: String, CodingKey {
        case name
        case version
        case rooted
        case kernelVersion = "kernel_version"
        case build
      }
    }

    public struct Device: Codable, Hashable, Sendable {
      public var model: String
      public var modelId: String
      public var family: String
      public var arch: String
      public var orientation: String
      public var thermalState: String
      public var simulator: Bool
      public var batteryLevel: Int
      public var locale: String
      public var charging: Bool
      public var processorCount: Int
      public var memorySize: Int
      public var usableMemory: Int
      public var freeMemory: Int

      public init(
        model: String,
        modelId: String,
        family: String,
        arch: String,
        orientation: String,
        thermalState: String,
        simulator: Bool,
        batteryLevel: Int,
        locale: String,
        charging: Bool,
        processorCount: Int,
        memorySize: Int,
        usableMemory: Int,
        freeMemory: Int
      ) {
        self.model = model
        self.modelId = modelId
        self.family = family
        self.arch = arch
        self.orientation = orientation
        self.thermalState = thermalState
        self.simulator = simulator
        self.batteryLevel = batteryLevel
        self.locale = locale
        self.charging = charging
        self.processorCount = processorCount
        self.memorySize = memorySize
        self.usableMemory = usableMemory
        self.freeMemory = freeMemory
      }

      private enum CodingKeys: String, CodingKey {
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

    public struct Trace: Codable, Hashable, Sendable {
      public var spanId: String
      public var traceId: String

      public init(
        spanId: String,
        traceId: String
      ) {
        self.spanId = spanId
        self.traceId = traceId
      }

      private enum CodingKeys: String, CodingKey {
        case spanId = "span_id"
        case traceId = "trace_id"
      }
    }

    public struct Culture: Codable, Hashable, Sendable {
      public var locale: String
      public var timezone: String
      public var displayName: String
      public var calendar: String
      public var is24HourFormat: Bool

      public init(
        locale: String,
        timezone: String,
        displayName: String,
        calendar: String,
        is24HourFormat: Bool
      ) {
        self.locale = locale
        self.timezone = timezone
        self.displayName = displayName
        self.calendar = calendar
        self.is24HourFormat = is24HourFormat
      }

      private enum CodingKeys: String, CodingKey {
        case locale
        case timezone
        case displayName = "display_name"
        case calendar
        case is24HourFormat = "is_24_hour_format"
      }
    }
  }

  public struct DebugMeta: Codable, Hashable, Sendable {
    public var images: [Image]

    init(images: [Image]) {
      self.images = images
    }

    public struct Image: Codable, Hashable, Sendable {
      public var debugId: String
      public var imageAddress: String
      public var type: String
      public var imageSize: Int
      public var codeFile: String

      public init(
        debugId: String,
        imageAddress: String,
        type: String,
        imageSize: Int,
        codeFile: String
      ) {
        self.debugId = debugId
        self.imageAddress = imageAddress
        self.type = type
        self.imageSize = imageSize
        self.codeFile = codeFile
      }

      private enum CodingKeys: String, CodingKey {
        case debugId = "debug_id"
        case imageAddress = "image_addr"
        case type
        case imageSize = "image_size"
        case codeFile = "code_file"
      }
    }
  }
}
