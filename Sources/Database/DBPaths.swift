//
//  DBPaths.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 15/10/2024.
//


import Foundation
import DiscordModels

struct DBPaths {
  private static let dbDirectory: URL = {
    // we get the executable path first
    guard let execPath = Bundle.main.executableURL?.deletingLastPathComponent() else { fatalError("DB: Unable to get the current executable directory.") }
    // store stuff in db directory
    let dbPath = execPath.appendingPathComponent("db", isDirectory: true)
    return dbPath
  }()
  
  // we use `try!` because we should be able to make directories, this
  // is bad if we cant so we might as well go down trying
  
  static let Users: Self = {
    let path = Self.dbDirectory.appendingPathComponent("users", isDirectory: true)
    try! FileManager.default.createDirectory(at: path, withIntermediateDirectories: true)
    return .init(url: path)
  }()
  static let Guilds: Self = {
    let path = Self.dbDirectory.appendingPathComponent("guilds", isDirectory: true)
    try! FileManager.default.createDirectory(at: path, withIntermediateDirectories: true)
    return .init(url: path)
  }()
  static let Bot: Self = {
    let path = Self.dbDirectory.appendingPathComponent("bot", isDirectory: true)
    try! FileManager.default.createDirectory(at: path, withIntermediateDirectories: true)
    return .init(url: path)
  }()
  
  var url: URL
}