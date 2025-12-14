//
//  Speedtest.swift
//  rig
//
//  Created by Lakhan Lothiyi on 16/10/2024.
//

import Foundation

enum Speedtest {
  static func isInstalled() -> Bool {
    FileManager.default.fileExists(atPath: "/usr/local/bin/speedtest")
      || FileManager.default.fileExists(atPath: "/opt/homebrew/bin/speedtest")
      || FileManager.default.fileExists(atPath: "/usr/bin/speedtest")
  }

  static let dec = JSONDecoder()

  static func speedtest(
    download: @escaping (Speedtest) async -> Void,
    upload: @escaping (Speedtest) async -> Void
  ) async throws {
    guard self.isInstalled() else { throw Error.notInstalled }
    let dl = try await exec(type: .download)
    await download(dl)
    var ul = try await exec(id: dl.server.id, type: .upload)
    ul.bytesReceived = dl.bytesReceived
    ul.download = dl.download
    ul.ping = (dl.ping + ul.ping) / 2
    await upload(ul)
  }

  static private func exec(id: String? = nil, type: TestType) async throws
    -> Speedtest
  {
    let process = Process()
    let pipe = Pipe()

    if FileManager.default.fileExists(atPath: "/usr/local/bin/speedtest") {
      process.executableURL = .init(fileURLWithPath: "/usr/local/bin/speedtest")
    } else if FileManager.default.fileExists(
      atPath: "/opt/homebrew/bin/speedtest"
    ) {
      process.executableURL = .init(
        fileURLWithPath: "/opt/homebrew/bin/speedtest"
      )
    } else {
      process.executableURL = .init(fileURLWithPath: "/usr/bin/speedtest")
    }
    process.arguments = ["--json", type.rawValue]
    if let id {
      process.arguments?.append(contentsOf: ["--server", id])
    }
    process.standardOutput = pipe
    process.standardError = pipe

    try process.run()
    process.waitUntilExit()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    do {
      return try dec.decode(Speedtest.self, from: data)
    } catch {
      throw Error.speedtestError(
        String(data: data, encoding: .utf8)
          ?? String(reflecting: error.localizedDescription)
      )
    }
  }

  enum TestType: String {
    case download = "--no-upload"
    case upload = "--no-download"
  }
  enum Error: LocalizedError {
    case notInstalled
    case speedtestError(String)
    var errorDescription: String? {
      switch self {
      case .notInstalled:
        "Speedtest is not installed, please install it."
      case .speedtestError(let str):
        "Speedtest encountered an error.\n\n\(str)"
      }
    }
  }

  // MARK: - Speedtest
  struct Speedtest: Codable {
    var download, upload, ping: Double
    let server: Server
    let timestamp: String
    var bytesSent, bytesReceived: Int
    let client: Client

    enum CodingKeys: String, CodingKey {
      case download, upload, ping, server, timestamp
      case bytesSent = "bytes_sent"
      case bytesReceived = "bytes_received"
      case client
    }
  }

  // MARK: - Client
  struct Client: Codable {
    let isp: String
  }

  // MARK: - Server
  struct Server: Codable {
    let sponsor: String
    let id: String
  }
}
