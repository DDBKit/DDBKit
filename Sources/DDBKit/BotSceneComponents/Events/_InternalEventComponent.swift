//
//  BotEventComponent.swift
//
//
//  Created by Lakhan Lothiyi on 22/03/2024.
//

import DiscordBM

// this protocol is used to give all events conformance to receive events.
public protocol BaseEvent<T>: BotScene {
  associatedtype T: Codable
  var action: (T) async -> Void { get set }
  var eventType: Gateway.Event.EventType { get }
  func typeMatchesEvent(_ event: Gateway.Event) -> Bool
}

extension BaseEvent {
  public func typeMatchesEvent(_ event: Gateway.Event) -> Bool {
    event.isOfType(eventType)
  }
  func handle(_ data: Gateway.Event.Payload?) async {
    guard let ix = data?.asType(T.self)
    else { return GS.s.logger.debug("Failed to cast payload as defined type \(T.self)") }
    await self.action(ix)
  }
}

// below is what i wouldn't wish upon anyone else no matter what
// terrible things they may have done

// i couldn't find a better way to do this

public extension Gateway.Event.Payload {
  func asType<T>(_ type: T.Type) -> T? { // swiftlint:disable:this cyclomatic_complexity function_body_length
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
    case .messagePollVoteAdd(let messagePollVoteAdd):
      return messagePollVoteAdd as? T
    case .messagePollVoteRemove(let messagePollVoteRemove):
      return messagePollVoteRemove as? T
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
  func isOfType(_ type: EventType) -> Bool { // swiftlint:disable:this cyclomatic_complexity function_body_length
    switch self.data {
    case .heartbeat:
      return type == .heartbeat
    case .identify:
      return type == .identify
    case .hello:
      return type == .hello
    case .ready:
      return type == .ready
    case .resume:
      return type == .resume
    case .resumed:
      return type == .resumed
    case .invalidSession:
      return type == .invalidSession
    case .channelCreate:
      return type == .channelCreate
    case .channelUpdate:
      return type == .channelUpdate
    case .channelDelete:
      return type == .channelDelete
    case .channelPinsUpdate:
      return type == .channelPinsUpdate
    case .threadCreate:
      return type == .threadCreate
    case .threadUpdate:
      return type == .threadUpdate
    case .threadDelete:
      return type == .threadDelete
    case .threadSyncList:
      return type == .threadSyncList
    case .threadMemberUpdate:
      return type == .threadMemberUpdate
    case .threadMembersUpdate:
      return type == .threadMembersUpdate
    case .entitlementCreate:
      return type == .entitlementCreate
    case .entitlementUpdate:
      return type == .entitlementUpdate
    case .entitlementDelete:
      return type == .entitlementDelete
    case .guildCreate:
      return type == .guildCreate
    case .guildUpdate:
      return type == .guildUpdate
    case .guildDelete:
      return type == .guildDelete
    case .guildBanAdd:
      return type == .guildBanAdd
    case .guildBanRemove:
      return type == .guildBanRemove
    case .guildEmojisUpdate:
      return type == .guildEmojisUpdate
    case .guildStickersUpdate:
      return type == .guildStickersUpdate
    case .guildIntegrationsUpdate:
      return type == .guildIntegrationsUpdate
    case .guildMemberAdd:
      return type == .guildMemberAdd
    case .guildMemberRemove:
      return type == .guildMemberRemove
    case .guildMemberUpdate:
      return type == .guildMemberUpdate
    case .guildMembersChunk:
      return type == .guildMembersChunk
    case .requestGuildMembers:
      return type == .requestGuildMembers
    case .guildRoleCreate:
      return type == .guildRoleCreate
    case .guildRoleUpdate:
      return type == .guildRoleUpdate
    case .guildRoleDelete:
      return type == .guildRoleDelete
    case .guildScheduledEventCreate:
      return type == .guildScheduledEventCreate
    case .guildScheduledEventUpdate:
      return type == .guildScheduledEventUpdate
    case .guildScheduledEventDelete:
      return type == .guildScheduledEventDelete
    case .guildScheduledEventUserAdd:
      return type == .guildScheduledEventUserAdd
    case .guildScheduledEventUserRemove:
      return type == .guildScheduledEventUserRemove
    case .guildAuditLogEntryCreate:
      return type == .guildAuditLogEntryCreate
    case .integrationCreate:
      return type == .integrationCreate
    case .integrationUpdate:
      return type == .integrationUpdate
    case .integrationDelete:
      return type == .integrationDelete
    case .interactionCreate:
      return type == .interactionCreate
    case .inviteCreate:
      return type == .inviteCreate
    case .inviteDelete:
      return type == .inviteDelete
    case .messageCreate:
      return type == .messageCreate
    case .messageUpdate:
      return type == .messageUpdate
    case .messageDelete:
      return type == .messageDelete
    case .messageDeleteBulk:
      return type == .messageDeleteBulk
    case .messageReactionAdd:
      return type == .messageReactionAdd
    case .messageReactionRemove:
      return type == .messageReactionRemove
    case .messageReactionRemoveAll:
      return type == .messageReactionRemoveAll
    case .messageReactionRemoveEmoji:
      return type == .messageReactionRemoveEmoji
    case .messagePollVoteAdd:
      return type == .messagePollVoteAdd
    case .messagePollVoteRemove:
      return type == .messagePollVoteRemove
    case .presenceUpdate:
      return type == .presenceUpdate
    case .requestPresenceUpdate:
      return type == .requestPresenceUpdate
    case .stageInstanceCreate:
      return type == .stageInstanceCreate
    case .stageInstanceDelete:
      return type == .stageInstanceDelete
    case .stageInstanceUpdate:
      return type == .stageInstanceUpdate
    case .typingStart:
      return type == .typingStart
    case .userUpdate:
      return type == .userUpdate
    case .voiceStateUpdate:
      return type == .voiceStateUpdate
    case .requestVoiceStateUpdate:
      return type == .requestVoiceStateUpdate
    case .voiceServerUpdate:
      return type == .voiceServerUpdate
    case .webhooksUpdate:
      return type == .webhooksUpdate
    case .applicationCommandPermissionsUpdate:
      return type == .applicationCommandPermissionsUpdate
    case .autoModerationRuleCreate:
      return type == .autoModerationRuleCreate
    case .autoModerationRuleUpdate:
      return type == .autoModerationRuleUpdate
    case .autoModerationRuleDelete:
      return type == .autoModerationRuleDelete
    case .autoModerationActionExecution:
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
    case messagePollVoteAdd
    case messagePollVoteRemove
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
} // swiftlint:disable:this file_length
