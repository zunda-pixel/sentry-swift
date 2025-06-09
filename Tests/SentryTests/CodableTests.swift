import Foundation
import Sentry
import Testing

@Suite
struct CodableTests {
  @Test
  func event() async throws {
    let url = Bundle.module.url(forResource: "Event", withExtension: "json")!
    let data = try Data(contentsOf: url)
    let event1 = try JSONDecoder().decode(Event.self, from: data)
    let encodedData = try JSONEncoder().encode(event1)
    let event2 = try JSONDecoder().decode(Event.self, from: encodedData)
    print(event1, event2)
  }

  @Test
  func errorEvent() async throws {
    let url = Bundle.module.url(forResource: "ErrorEvent", withExtension: "json")!
    let data = try Data(contentsOf: url)
    let event1 = try JSONDecoder().decode(ErrorEvent.self, from: data)
    let encodedData = try JSONEncoder().encode(event1)
    let event2 = try JSONDecoder().decode(ErrorEvent.self, from: encodedData)
    print(event1, event2)
  }

  @Test
  func logEvent() async throws {
    let url = Bundle.module.url(forResource: "LogEvent", withExtension: "json")!
    let data = try Data(contentsOf: url)

    let event1 = try JSONDecoder().decode(LogEvent<Empty, Empty>.self, from: data)
    let encodedData = try JSONEncoder().encode(event1)
    let event2 = try JSONDecoder().decode(LogEvent<Empty, Empty>.self, from: encodedData)
    print(event1, event2)
  }
}

struct Empty: Codable & Sendable & Hashable {}
