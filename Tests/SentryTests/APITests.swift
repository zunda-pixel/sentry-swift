import Foundation
import Sentry
import Testing

@Suite
struct APITests {
  let client = Client(
    organizationId: ProcessInfo.processInfo.environment["ORGANIZATION_ID"]!,
    projectId: ProcessInfo.processInfo.environment["PROJECT_ID"]!,
    apiToken: ProcessInfo.processInfo.environment["API_TOKEN"]!,
    httpClient: .urlSession(.shared)
  )

  @Test
  func postEvent() async throws {
    let event = Event(
      eventId: UUID().uuidString,
      sentAt: .now,
      trace: .init(
        traceId: UUID().uuidString,
        publicKey: UUID().uuidString,
        release: "com.zunda.TestSentry@1.0+1",
        environment: "production"
      ),
      sdk: .init(
        name: "sentry.cocoa",
        version: "8.52.1",
        packages: [
          .init(name: "carthage:getsentry/sentry.cocoa", version: "8.52.1")
        ],
        features: [
          "dataSwizzling",
          "captureFailedRequests",
          "experimentalViewRenderer",
        ],
        integrations: [
          "AutoSessionTracking",
          "NetworkTracking",
          "WatchdogTerminationTracking",
          "Crash",
          "AutoBreadcrumbTracking",
        ]
      )
    )
    let log = LogEvent<Empty, Empty>(
      eventId: UUID().uuidString,
      environment: "production",
      level: "error",
      platform: "cocoa",
      timestamp: .now,
      release: "com.zunda.TestSentry@1.0+1",
      dist: "1",
      user: .init(id: .init()),
      extra: .init(),
      exception: .init(values: [
        .init(
          value: "erro1 (Code: 0)", type: "TestSentry.SomeError",
          mechanism: .init(
            data: .init(), meta: .init(), type: "NSError",
            description: "TestSentry.SomeError.error1"))
      ]),
      tags: .init(),
      breadcrumbs: [
        .init(
          timestamp: .now, level: "info", type: "debug", category: "started",
          message: "Breadcrumb Tracking")
      ],
      threads: .init(
        values: [
          .init(
            id: 1,
            current: true,
            crashed: false,
            main: true
          )
        ]
      ),
      contexts: .init(
        app: .init(
          appName: "TestSentry",
          buildType: "enterprise",
          appVersion: "1.0",
          appIdentifier: "com.zunda.TestSentry",
          appStartTime: .now,
          appId: UUID().uuidString,
          deviceAppHash: UUID().uuidString,
          inForeground: true,
          appBuild: "1",
          appMemory: 1_454_234,
          viewNames: [
            "UIHostingController<modifiedContent<AnyView, RootModifier>>"
          ]
        ),
        os: .init(
          name: "iOS",
          version: "18.5",
          rooted: false,
          kernelVersion:
            "Darwin Kernel Version 24.5.0: Tue Apr 22 20:38:09 PDT 2025; root:xnu-11417.122.4~1/RELEASE_ARM64_T8140",
          build: "22F76"
        ),
        device: .init(
          model: "iPhone17,3",
          modelId: "D47AP",
          family: "iOS",
          arch: "arm64",
          orientation: "portrait",
          thermalState: "nominal",
          simulator: false,
          batteryLevel: 75,
          locale: "en_US",
          charging: false,
          processorCount: 6,
          memorySize: 3_211_325_148,
          usableMemory: 123_121_231,
          freeMemory: 123_123_123
        ),
        trace: .init(
          spanId: UUID().uuidString,
          traceId: UUID().uuidString
        ),
        culture: .init(
          locale: "en_US",
          timezone: "Asia/Tokyo",
          displayName: "English (United States)",
          calendar: "Gregorian Calendar",
          is24HourFormat: false
        )
      ),
      sdk: .init(
        name: "sentry.cocoa",
        version: "8.52.1",
        packages: [
          .init(name: "carthage:getsentry/sentry.cocoa", version: "8.52.1")
        ],
        features: [
          "captureFailedRequests",
          "experimentalViewRenderer",
          "dataSwizzling",
        ],
        integrations: [
          "WatchdogTerminationTracking",
          "AutoBreadcrumbTracking",
          "AutoSessionTracking",
          "NetworkTracking",
          "Crash",
        ]
      ),
      debugMeta: .init(
        images: [
          .init(
            debugId: UUID().uuidString,
            imageAddress: UUID().uuidString,
            type: "macho",
            imageSize: 132131,
            codeFile: "/private/var/containers"
          )
        ]
      )
    )
    let error = ErrorEvent(
      errors: 2,
      status: "ok",
      started: .now,
      did: .init(),
      duration: 0,
      sid: .init(),
      attributes: .init(
        release: "com.zunda.TestSentry@1.0+1",
        environment: "production"
      ),
      timestamp: .now,
      sequence: 3
    )

    do {
      try await client.postLog(
        event: event,
        log: log,
        error: error
      )
    } catch let error as RequestError {
      print(String(decoding: error.data, as: UTF8.self))
      print(error.response)
      throw error
    }
  }
}
