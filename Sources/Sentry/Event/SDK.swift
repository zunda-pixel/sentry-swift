public struct SDK: Codable {
  public var name: String
  public var version: String
  public var packages: [Package]
  public var features: [String]
  public var integrations: [String]

  public init(
    name: String,
    version: String,
    packages: [Package],
    features: [String],
    integrations: [String]
  ) {
    self.name = name
    self.version = version
    self.packages = packages
    self.features = features
    self.integrations = integrations
  }

  public struct Package: Codable {
    public var name: String
    public var version: String

    public init(
      name: String,
      version: String
    ) {
      self.name = name
      self.version = version
    }
  }
}
