@_exported import DiscordBM
@_exported import AsyncHTTPClient
import Logging

// the following was borrowed from discordbm 

internal class GS: @unchecked Sendable {
  
  var label: String = "DDBKit"
  var makeLogger: @Sendable (String) -> Logger = { Logger(label: $0) }
  
  init() {
    self.logger = makeLogger(label)
  }
  
  var logger: Logger
  
  static let s = GS()
}

/// A container for **on-boot & one-time-only** configuration options.
public enum DDBKitGlobalConfiguration {
  /// Function to make loggers with. You can override it with your own logger.
  /// The `String` argument represents the label of the logger.
  public static var makeLogger: @Sendable (String) -> Logger {
    get { GS.s.makeLogger }
    set { GS.s.makeLogger = newValue }
  }
}
