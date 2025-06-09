import HTTPTypes

extension HTTPField.Name {
  public static var host: Self { .init("Host")! }
  public static var xSentryAuth: Self { .init("X-Sentry-Auth")! }
}
