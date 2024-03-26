//
//  BotEventComponent.swift
//
//
//  Created by Lakhan Lothiyi on 22/03/2024.
//

import DiscordBM

public struct Event: BotScene {
  var eventType: Gateway.Event.EventType
  
  public init(on type: Gateway.Event.EventType, action: @escaping (Gateway.Event.Payload?) async -> Void) {
    self.eventType = type
    self.action = action
  }
  
  var action: (Gateway.Event.Payload?) async -> Void
  
  func typeMatchesEvent(_ event: Gateway.Event) -> Bool { event.isOfType(self.eventType) }
}

public extension Gateway.Event.Payload {
  func asType<T>(_ type: T.Type) -> T? {
    switch self {
    case .heartbeat(let lastSequenceNumber):
      return lastSequenceNumber as? T
    case .identify(let identify):
      return identify as? T
    case .hello(let hello):
      return hello as? T
    case .ready(let ready):
      return ready as? T
    case .resume(let resume):
      return resume as? T
    case .resumed:
      return nil
    case .invalidSession(let canResume):
      return canResume as? T
    case .channelCreate(let discordChannel):
      return discordChannel as? T
    case .channelUpdate(let discordChannel):
      return discordChannel as? T
    case .channelDelete(let discordChannel):
      return discordChannel as? T
    case .channelPinsUpdate(let channelPinsUpdate):
      return channelPinsUpdate as? T
    case .threadCreate(let discordChannel):
      return discordChannel as? T
    case .threadUpdate(let discordChannel):
      return discordChannel as? T
    case .threadDelete(let threadDelete):
      return threadDelete as? T
    case .threadSyncList(let threadListSync):
      return threadListSync as? T
    case .threadMemberUpdate(let threadMemberUpdate):
      return threadMemberUpdate as? T
    case .threadMembersUpdate(let threadMembersUpdate):
      return threadMembersUpdate as? T
    case .entitlementCreate(let entitlement):
      return entitlement as? T
    case .entitlementUpdate(let entitlement):
      return entitlement as? T
    case .entitlementDelete(let entitlement):
      return entitlement as? T
    case .guildCreate(let guildCreate):
      return guildCreate as? T
    case .guildUpdate(let guild):
      return guild as? T
    case .guildDelete(let unavailableGuild):
      return unavailableGuild as? T
    case .guildBanAdd(let guildBan):
      return guildBan as? T
    case .guildBanRemove(let guildBan):
      return guildBan as? T
    case .guildEmojisUpdate(let guildEmojisUpdate):
      return guildEmojisUpdate as? T
    case .guildStickersUpdate(let guildStickersUpdate):
      return guildStickersUpdate as? T
    case .guildIntegrationsUpdate(let guildIntegrationsUpdate):
      return guildIntegrationsUpdate as? T
    case .guildMemberAdd(let guildMemberAdd):
      return guildMemberAdd as? T
    case .guildMemberRemove(let guildMemberRemove):
      return guildMemberRemove as? T
    case .guildMemberUpdate(let guildMemberAdd):
      return guildMemberAdd as? T
    case .guildMembersChunk(let guildMembersChunk):
      return guildMembersChunk as? T
    case .requestGuildMembers(let requestGuildMembers):
      return requestGuildMembers as? T
    case .guildRoleCreate(let guildRole):
      return guildRole as? T
    case .guildRoleUpdate(let guildRole):
      return guildRole as? T
    case .guildRoleDelete(let guildRoleDelete):
      return guildRoleDelete as? T
    case .guildScheduledEventCreate(let guildScheduledEvent):
      return guildScheduledEvent as? T
    case .guildScheduledEventUpdate(let guildScheduledEvent):
      return guildScheduledEvent as? T
    case .guildScheduledEventDelete(let guildScheduledEvent):
      return guildScheduledEvent as? T
    case .guildScheduledEventUserAdd(let guildScheduledEventUser):
      return guildScheduledEventUser as? T
    case .guildScheduledEventUserRemove(let guildScheduledEventUser):
      return guildScheduledEventUser as? T
    case .guildAuditLogEntryCreate(let entry):
      return entry as? T
    case .integrationCreate(let integrationCreate):
      return integrationCreate as? T
    case .integrationUpdate(let integrationCreate):
      return integrationCreate as? T
    case .integrationDelete(let integrationDelete):
      return integrationDelete as? T
    case .interactionCreate(let interaction):
      return interaction as? T
    case .inviteCreate(let inviteCreate):
      return inviteCreate as? T
    case .inviteDelete(let inviteDelete):
      return inviteDelete as? T
    case .messageCreate(let messageCreate):
      return messageCreate as? T
    case .messageUpdate(let partialMessage):
      return partialMessage as? T
    case .messageDelete(let messageDelete):
      return messageDelete as? T
    case .messageDeleteBulk(let messageDeleteBulk):
      return messageDeleteBulk as? T
    case .messageReactionAdd(let messageReactionAdd):
      return messageReactionAdd as? T
    case .messageReactionRemove(let messageReactionRemove):
      return messageReactionRemove as? T
    case .messageReactionRemoveAll(let messageReactionRemoveAll):
      return messageReactionRemoveAll as? T
    case .messageReactionRemoveEmoji(let messageReactionRemoveEmoji):
      return messageReactionRemoveEmoji as? T
    case .presenceUpdate(let presenceUpdate):
      return presenceUpdate as? T
    case .requestPresenceUpdate(let presence):
      return presence as? T
    case .stageInstanceCreate(let stageInstance):
      return stageInstance as? T
    case .stageInstanceDelete(let stageInstance):
      return stageInstance as? T
    case .stageInstanceUpdate(let stageInstance):
      return stageInstance as? T
    case .typingStart(let typingStart):
      return typingStart as? T
    case .userUpdate(let discordUser):
      return discordUser as? T
    case .voiceStateUpdate(let voiceState):
      return voiceState as? T
    case .requestVoiceStateUpdate(let voiceStateUpdate):
      return voiceStateUpdate as? T
    case .voiceServerUpdate(let voiceServerUpdate):
      return voiceServerUpdate as? T
    case .webhooksUpdate(let webhooksUpdate):
      return webhooksUpdate as? T
    case .applicationCommandPermissionsUpdate(let guildApplicationCommandPermissions):
      return guildApplicationCommandPermissions as? T
    case .autoModerationRuleCreate(let autoModerationRule):
      return autoModerationRule as? T
    case .autoModerationRuleUpdate(let autoModerationRule):
      return autoModerationRule as? T
    case .autoModerationRuleDelete(let autoModerationRule):
      return autoModerationRule as? T
    case .autoModerationActionExecution(let autoModerationActionExecution):
      return autoModerationActionExecution as? T
    case .__undocumented:
      return nil
    }
  }
}


extension Gateway.Event {
  
  func isOfType(_ type: EventType) -> Bool {
    switch self.data {
    case .heartbeat(lastSequenceNumber: _):
      return type == .heartbeat
    case .identify(_):
      return type == .identify
    case .hello(_):
      return type == .hello
    case .ready(_):
      return type == .ready
    case .resume(_):
      return type == .resume
    case .resumed:
      return type == .resumed
    case .invalidSession(canResume: _):
      return type == .invalidSession
    case .channelCreate(_):
      return type == .channelCreate
    case .channelUpdate(_):
      return type == .channelUpdate
    case .channelDelete(_):
      return type == .channelDelete
    case .channelPinsUpdate(_):
      return type == .channelPinsUpdate
    case .threadCreate(_):
      return type == .threadCreate
    case .threadUpdate(_):
      return type == .threadUpdate
    case .threadDelete(_):
      return type == .threadDelete
    case .threadSyncList(_):
      return type == .threadSyncList
    case .threadMemberUpdate(_):
      return type == .threadMemberUpdate
    case .threadMembersUpdate(_):
      return type == .threadMembersUpdate
    case .entitlementCreate(_):
      return type == .entitlementCreate
    case .entitlementUpdate(_):
      return type == .entitlementUpdate
    case .entitlementDelete(_):
      return type == .entitlementDelete
    case .guildCreate(_):
      return type == .guildCreate
    case .guildUpdate(_):
      return type == .guildUpdate
    case .guildDelete(_):
      return type == .guildDelete
    case .guildBanAdd(_):
      return type == .guildBanAdd
    case .guildBanRemove(_):
      return type == .guildBanRemove
    case .guildEmojisUpdate(_):
      return type == .guildEmojisUpdate
    case .guildStickersUpdate(_):
      return type == .guildStickersUpdate
    case .guildIntegrationsUpdate(_):
      return type == .guildIntegrationsUpdate
    case .guildMemberAdd(_):
      return type == .guildMemberAdd
    case .guildMemberRemove(_):
      return type == .guildMemberRemove
    case .guildMemberUpdate(_):
      return type == .guildMemberUpdate
    case .guildMembersChunk(_):
      return type == .guildMembersChunk
    case .requestGuildMembers(_):
      return type == .requestGuildMembers
    case .guildRoleCreate(_):
      return type == .guildRoleCreate
    case .guildRoleUpdate(_):
      return type == .guildRoleUpdate
    case .guildRoleDelete(_):
      return type == .guildRoleDelete
    case .guildScheduledEventCreate(_):
      return type == .guildScheduledEventCreate
    case .guildScheduledEventUpdate(_):
      return type == .guildScheduledEventUpdate
    case .guildScheduledEventDelete(_):
      return type == .guildScheduledEventDelete
    case .guildScheduledEventUserAdd(_):
      return type == .guildScheduledEventUserAdd
    case .guildScheduledEventUserRemove(_):
      return type == .guildScheduledEventUserRemove
    case .guildAuditLogEntryCreate(_):
      return type == .guildAuditLogEntryCreate
    case .integrationCreate(_):
      return type == .integrationCreate
    case .integrationUpdate(_):
      return type == .integrationUpdate
    case .integrationDelete(_):
      return type == .integrationDelete
    case .interactionCreate(_):
      return type == .interactionCreate
    case .inviteCreate(_):
      return type == .inviteCreate
    case .inviteDelete(_):
      return type == .inviteDelete
    case .messageCreate(_):
      return type == .messageCreate
    case .messageUpdate(_):
      return type == .messageUpdate
    case .messageDelete(_):
      return type == .messageDelete
    case .messageDeleteBulk(_):
      return type == .messageDeleteBulk
    case .messageReactionAdd(_):
      return type == .messageReactionAdd
    case .messageReactionRemove(_):
      return type == .messageReactionRemove
    case .messageReactionRemoveAll(_):
      return type == .messageReactionRemoveAll
    case .messageReactionRemoveEmoji(_):
      return type == .messageReactionRemoveEmoji
    case .presenceUpdate(_):
      return type == .presenceUpdate
    case .requestPresenceUpdate(_):
      return type == .requestPresenceUpdate
    case .stageInstanceCreate(_):
      return type == .stageInstanceCreate
    case .stageInstanceDelete(_):
      return type == .stageInstanceDelete
    case .stageInstanceUpdate(_):
      return type == .stageInstanceUpdate
    case .typingStart(_):
      return type == .typingStart
    case .userUpdate(_):
      return type == .userUpdate
    case .voiceStateUpdate(_):
      return type == .voiceStateUpdate
    case .requestVoiceStateUpdate(_):
      return type == .requestVoiceStateUpdate
    case .voiceServerUpdate(_):
      return type == .voiceServerUpdate
    case .webhooksUpdate(_):
      return type == .webhooksUpdate
    case .applicationCommandPermissionsUpdate(_):
      return type == .applicationCommandPermissionsUpdate
    case .autoModerationRuleCreate(_):
      return type == .autoModerationRuleCreate
    case .autoModerationRuleUpdate(_):
      return type == .autoModerationRuleUpdate
    case .autoModerationRuleDelete(_):
      return type == .autoModerationRuleDelete
    case .autoModerationActionExecution(_):
      return type == .autoModerationActionExecution
    case .__undocumented:
      return false // Handle undocumented case, if necessary
    case .none:
      return false
    }
  }
  
  public enum EventType: Sendable {
    case heartbeat
    case identify
    case hello
    case ready
    case resume
    case resumed
    case invalidSession
    case channelCreate
    case channelUpdate
    case channelDelete
    case channelPinsUpdate
    case threadCreate
    case threadUpdate
    case threadDelete
    case threadSyncList
    case threadMemberUpdate
    case threadMembersUpdate
    case entitlementCreate
    case entitlementUpdate
    case entitlementDelete
    case guildCreate
    case guildUpdate
    case guildDelete
    case guildBanAdd
    case guildBanRemove
    case guildEmojisUpdate
    case guildStickersUpdate
    case guildIntegrationsUpdate
    case guildMemberAdd
    case guildMemberRemove
    case guildMemberUpdate
    case guildMembersChunk
    case requestGuildMembers
    case guildRoleCreate
    case guildRoleUpdate
    case guildRoleDelete
    case guildScheduledEventCreate
    case guildScheduledEventUpdate
    case guildScheduledEventDelete
    case guildScheduledEventUserAdd
    case guildScheduledEventUserRemove
    case guildAuditLogEntryCreate
    case integrationCreate
    case integrationUpdate
    case integrationDelete
    case interactionCreate
    case inviteCreate
    case inviteDelete
    case messageCreate
    case messageUpdate
    case messageDelete
    case messageDeleteBulk
    case messageReactionAdd
    case messageReactionRemove
    case messageReactionRemoveAll
    case messageReactionRemoveEmoji
    case presenceUpdate
    case requestPresenceUpdate
    case stageInstanceCreate
    case stageInstanceDelete
    case stageInstanceUpdate
    case typingStart
    case userUpdate
    case voiceStateUpdate
    case requestVoiceStateUpdate
    case voiceServerUpdate
    case webhooksUpdate
    case applicationCommandPermissionsUpdate
    case autoModerationRuleCreate
    case autoModerationRuleUpdate
    case autoModerationRuleDelete
    case autoModerationActionExecution
  }

}
