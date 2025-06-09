import Foundation
import Gzip
import HTTPTypes

extension Client {
  @discardableResult
  public func postLog<MechanismData: Codable, MechanismMeta: Codable>(
    event: Event,
    log: LogEvent<MechanismData, MechanismMeta>,
    error: ErrorEvent
  ) async throws -> String {
    let url = baseUrl.appending(path: "/envelope", directoryHint: .isDirectory)

    let encoder = JSONEncoder()
    let eventData = try encoder.encode(event)

    let logData = try encoder.encode(log)

    let eventLabel = DataLabel(type: "event", length: logData.count)
    let eventLabelData = try encoder.encode(eventLabel)

    let errorData = try encoder.encode(error)
    let sessionLabel = DataLabel(type: "session", length: errorData.count)
    let sessionLabelData = try encoder.encode(sessionLabel)

    let datas = [
      [
        eventData
      ],
      [
        eventLabelData,
        logData,
      ],
      [
        sessionLabelData,
        errorData,
      ],
    ].flatMap { $0 }

    let bodyDatas = datas.map { String(decoding: $0, as: UTF8.self) }

    let gzippedBodyData = try Data(bodyDatas.joined(separator: "\n").utf8).gzipped()

    let request = HTTPRequest(
      method: .post,
      url: url,
      headerFields: [
        .host: "o\(organizationId).ingest.us.sentry.io",
        .contentType: "application/x-sentry-envelope",
        .acceptEncoding: "gzip, deflate, br",
        .connection: "keep-alive",
        .accept: "*/*",
        .contentEncoding: "gzip",
        .userAgent: clientName,
        .xSentryAuth: [
          "Sentry sentry_version": "\(version)",
          "sentry_client": clientName,
          "sentry_key": apiToken,
        ].map { "\($0.key)=\($0.value)" }.joined(separator: ","),
        .contentLength: "\(gzippedBodyData.count)",
        .acceptLanguage: "en-US,en;q=0.9",
      ]
    )

    let (data, response) = try await httpClient.execute(
      for: request,
      from: gzippedBodyData
    )

    if let response = try? JSONDecoder().decode(Response.self, from: data) {
      return response.id
    } else {
      throw RequestError(
        data: data,
        response: response
      )
    }
  }
}

struct Response: Codable {
  var id: String
}

struct DataLabel: Codable {
  var type: String
  var length: Int
}

public struct RequestError: Error {
  public var data: Data
  public var response: HTTPResponse
}
