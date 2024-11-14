//
//  GatewayExtension.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 24/09/2024.
//

@_spi(Extensions) import DDBKit
import DDBKit
import DDBKitUtilities
import Database
import Foundation

final public class Configurator: DDBKitExtension {
  public var furtherReadings: [String: String] = [:]
  // we let the user specify types for configs and we use Mirrors to build the interface that bot-users can use to configure the bot with.
  
  let guildConfiguration: ConfigurationTemplate.Type?
  let channelConfiguration: ConfigurationTemplate.Type?
  let memberConfiguration: ConfigurationTemplate.Type?
  let roleConfiguration: ConfigurationTemplate.Type?
  let userConfiguration: ConfigurationTemplate.Type?
  
  public init(
    guildConfiguration: ConfigurationTemplate.Type? = nil,
    channelConfiguration: ConfigurationTemplate.Type? = nil,
    memberConfiguration: ConfigurationTemplate.Type? = nil,
    roleConfiguration: ConfigurationTemplate.Type? = nil,
    userConfiguration: ConfigurationTemplate.Type? = nil
  ) {
    self.guildConfiguration = guildConfiguration
    self.channelConfiguration = channelConfiguration
    self.memberConfiguration = memberConfiguration
    self.roleConfiguration = roleConfiguration
    self.userConfiguration = userConfiguration
  }
  
  public func onBoot(_ instance: inout BotInstance) async throws {
    
  }
}
