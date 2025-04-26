//
//  DDBKitExtension.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 21/11/2024.
//


import DiscordModels

public protocol DDBKitExtension: Actor {
  /// This method is ran before the bot is connected to the gateway.
  /// It is useful for configuring the bot instance or any of it's properties before command registration.
  /// You can use this to configure your own properties for your extension, or maybe store the bot instance reference for later.
  /// - Parameter instance: Bot instance reference.
  func onBoot(_ instance: inout BotInstance) async throws
  
  /// This is ran after `onBoot(_:) async throws` and before the bot is connected to the gateway,
  /// is where you can create your own commands and events for the bot to handle.
  /// Bear in mind that other extensions registered after this one will be able to modify your commands.
  /// - Parameter scene: Scene
  @BotSceneBuilder
  func register() -> [any BotScene]
  
  /// Manual event handling. Remember that this is not ran in its own `Task` context. It is ran from `MainActor`.
  /// - Parameters:
  ///   - instance: `BotInstance` reference
  ///   - event: The received event
  func onEvent(_ instance: BotInstance, event: Gateway.Event) async throws
}

// default implementations
extension DDBKitExtension {
  public func onBoot(_ instance: inout BotInstance) async throws {}
  
  public func onEvent(_ instance: BotInstance, event: Gateway.Event) async throws {}
  
  @BotSceneBuilder
  public func register() -> [any BotScene] { }
}
