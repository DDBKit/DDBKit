//
//  Events.swift
//
//
//  Created by Lakhan Lothiyi on 18/04/2024.
//

import Foundation

public struct IdentifyEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.Identify
  var eventType: Gateway.Event.EventType? = .identify
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct HelloEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.Hello
  var eventType: Gateway.Event.EventType? = .hello
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct ReadyEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.Ready
  var eventType: Gateway.Event.EventType? = .ready
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct ChannelCreateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = DiscordChannel
  var eventType: Gateway.Event.EventType? = .channelCreate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct ChannelUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = DiscordChannel
  var eventType: Gateway.Event.EventType? = .channelUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct ChannelDeleteEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = DiscordChannel
  var eventType: Gateway.Event.EventType? = .channelDelete
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct ChannelPinsUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.ChannelPinsUpdate
  var eventType: Gateway.Event.EventType? = .channelPinsUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct ThreadCreateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = DiscordChannel
  var eventType: Gateway.Event.EventType? = .threadCreate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct ThreadUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = DiscordChannel
  var eventType: Gateway.Event.EventType? = .threadUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct ThreadDeleteEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.ThreadDelete
  var eventType: Gateway.Event.EventType? = .threadDelete
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct ThreadSyncListEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.ThreadListSync
  var eventType: Gateway.Event.EventType? = .threadSyncList
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct ThreadMemberUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.ThreadMemberUpdate
  var eventType: Gateway.Event.EventType? = .threadMemberUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct ThreadMembersUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.ThreadMembersUpdate
  var eventType: Gateway.Event.EventType? = .threadMembersUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct EntitlementCreateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Entitlement
  var eventType: Gateway.Event.EventType? = .entitlementCreate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct EntitlementUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Entitlement
  var eventType: Gateway.Event.EventType? = .entitlementUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct EntitlementDeleteEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Entitlement
  var eventType: Gateway.Event.EventType? = .entitlementDelete
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct GuildCreateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.GuildCreate
  var eventType: Gateway.Event.EventType? = .guildCreate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct GuildUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Guild
  var eventType: Gateway.Event.EventType? = .guildUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct GuildDeleteEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = UnavailableGuild
  var eventType: Gateway.Event.EventType? = .guildDelete
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct GuildBanAddEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.GuildBan
  var eventType: Gateway.Event.EventType? = .guildBanAdd
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct GuildBanRemoveEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.GuildBan
  var eventType: Gateway.Event.EventType? = .guildBanRemove
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct GuildEmojisUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.GuildEmojisUpdate
  var eventType: Gateway.Event.EventType? = .guildEmojisUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct GuildStickersUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.GuildStickersUpdate
  var eventType: Gateway.Event.EventType? = .guildStickersUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct GuildIntegrationsUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.GuildIntegrationsUpdate
  var eventType: Gateway.Event.EventType? = .guildIntegrationsUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct GuildMemberAddEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.GuildMemberAdd
  var eventType: Gateway.Event.EventType? = .guildMemberAdd
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct GuildMemberUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.GuildMemberAdd
  var eventType: Gateway.Event.EventType? = .guildMemberUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct GuildMemberRemoveEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.GuildMemberRemove
  var eventType: Gateway.Event.EventType? = .guildMemberRemove
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct GuildMembersChunkEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.GuildMembersChunk
  var eventType: Gateway.Event.EventType? = .guildMembersChunk
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct RequestGuildMembersEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.RequestGuildMembers
  var eventType: Gateway.Event.EventType? = .requestGuildMembers
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct GuildRoleCreateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.GuildRole
  var eventType: Gateway.Event.EventType? = .guildRoleCreate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct GuildRoleUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.GuildRole
  var eventType: Gateway.Event.EventType? = .guildRoleUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct GuildRoleDeleteEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.GuildRoleDelete
  var eventType: Gateway.Event.EventType? = .guildRoleDelete
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct GuildScheduledEventCreateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = GuildScheduledEvent
  var eventType: Gateway.Event.EventType? = .guildScheduledEventCreate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct GuildScheduledEventUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = GuildScheduledEvent
  var eventType: Gateway.Event.EventType? = .guildScheduledEventUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct GuildScheduledEventDeleteEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = GuildScheduledEvent
  var eventType: Gateway.Event.EventType? = .guildScheduledEventDelete
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct GuildAuditLogEntryCreateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = AuditLog.Entry
  var eventType: Gateway.Event.EventType? = .guildAuditLogEntryCreate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct IntegrationCreateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.IntegrationCreate
  var eventType: Gateway.Event.EventType? = .integrationCreate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct IntegrationUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.IntegrationCreate
  var eventType: Gateway.Event.EventType? = .integrationUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct IntegrationDeleteEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.IntegrationDelete
  var eventType: Gateway.Event.EventType? = .integrationDelete
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct InteractionCreateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.Ready
  var eventType: Gateway.Event.EventType? = .interactionCreate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct InviteCreateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.InviteCreate
  var eventType: Gateway.Event.EventType? = .inviteCreate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct InviteDeleteEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.InviteDelete
  var eventType: Gateway.Event.EventType? = .inviteDelete
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct MessageCreateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.MessageCreate
  var eventType: Gateway.Event.EventType? = .messageCreate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct MessageUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = DiscordChannel.PartialMessage
  var eventType: Gateway.Event.EventType? = .messageUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct MessageDeleteEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.MessageDelete
  var eventType: Gateway.Event.EventType? = .messageDelete
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct MessageDeleteBulkEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.MessageDeleteBulk
  var eventType: Gateway.Event.EventType? = .messageDeleteBulk
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct MessageReactionAddEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.MessageReactionAdd
  var eventType: Gateway.Event.EventType? = .messageReactionAdd
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct MessageReactionRemoveEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.MessageReactionRemove
  var eventType: Gateway.Event.EventType? = .messageReactionRemove
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct MessageReactionRemoveAllEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.MessageReactionRemoveAll
  var eventType: Gateway.Event.EventType? = .messageReactionRemoveAll
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct MessageReactionRemoveEmojiEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.MessageReactionRemoveEmoji
  var eventType: Gateway.Event.EventType? = .messageReactionRemoveEmoji
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct PresenceUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.PresenceUpdate
  var eventType: Gateway.Event.EventType? = .presenceUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct RequestPresenceUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.Identify.Presence
  var eventType: Gateway.Event.EventType? = .requestPresenceUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct StageInstanceCreateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = StageInstance
  var eventType: Gateway.Event.EventType? = .stageInstanceCreate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct StageInstanceDeleteEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = StageInstance
  var eventType: Gateway.Event.EventType? = .stageInstanceDelete
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct StageInstanceUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = StageInstance
  var eventType: Gateway.Event.EventType? = .stageInstanceUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct TypingStartEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.TypingStart
  var eventType: Gateway.Event.EventType? = .typingStart
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct UserUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = DiscordUser
  var eventType: Gateway.Event.EventType? = .userUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct VoiceStateUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = VoiceState
  var eventType: Gateway.Event.EventType? = .voiceStateUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct RequestVoiceStateUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = VoiceStateUpdate
  var eventType: Gateway.Event.EventType? = .requestVoiceStateUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct VoiceServerUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.VoiceServerUpdate
  var eventType: Gateway.Event.EventType? = .voiceServerUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct WebhooksEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.WebhooksUpdate
  var eventType: Gateway.Event.EventType? = .webhooksUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct ApplicationCommandPermissionsUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = GuildApplicationCommandPermissions
  var eventType: Gateway.Event.EventType? = .applicationCommandPermissionsUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct AutoModerationRuleCreateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = AutoModerationRule
  var eventType: Gateway.Event.EventType? = .autoModerationRuleCreate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct AutoModerationRuleUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = AutoModerationRule
  var eventType: Gateway.Event.EventType? = .autoModerationRuleUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct AutoModerationRuleRemoveEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = AutoModerationRule
  var eventType: Gateway.Event.EventType? = .autoModerationRuleDelete
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct AutoModerationActionExecutionEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = AutoModerationActionExecution
  var eventType: Gateway.Event.EventType? = .autoModerationActionExecution
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}
