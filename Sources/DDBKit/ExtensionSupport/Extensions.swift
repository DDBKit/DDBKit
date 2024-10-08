//
//  Extensions.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 02/10/2024.
//

import DiscordBM

/// An extension receives events, along with the bot context.
/// Due to having a slightly different use-case, it's largely copied from
/// `GatewayEventHandler`.
/// The `BotInstance` object part of a DDBKit bot will initialize your extension and
/// feed it events as they come through.
public protocol DDBKitExtension {
  var bot: any GatewayManager { get set }
  
  /// To be executed before handling events.
  /// If returns `false`, the event won't be passed to the functions below anymore.
  func onEventHandlerStart() async throws -> Bool
  func onEventHandlerEnd() async throws
  
  // MARK: State-management data
  func onHeartbeat(lastSequenceNumber: Int?) async throws
  func onHello(_ payload: Gateway.Hello) async throws
  func onReady(_ payload: Gateway.Ready) async throws
  func onResumed() async throws
  func onInvalidSession(canResume: Bool) async throws
  
  // MARK: Events
  func onChannelCreate(_ payload: DiscordChannel) async throws
  func onChannelUpdate(_ payload: DiscordChannel) async throws
  func onChannelDelete(_ payload: DiscordChannel) async throws
  func onChannelPinsUpdate(_ payload: Gateway.ChannelPinsUpdate) async throws
  func onThreadCreate(_ payload: DiscordChannel) async throws
  func onThreadUpdate(_ payload: DiscordChannel) async throws
  func onThreadDelete(_ payload: Gateway.ThreadDelete) async throws
  func onThreadSyncList(_ payload: Gateway.ThreadListSync) async throws
  func onThreadMemberUpdate(_ payload: Gateway.ThreadMemberUpdate) async throws
  func onThreadMembersUpdate(_ payload: Gateway.ThreadMembersUpdate) async throws
  func onEntitlementCreate(_ payload: Entitlement) async throws
  func onEntitlementUpdate(_ payload: Entitlement) async throws
  func onEntitlementDelete(_ payload: Entitlement) async throws
  func onGuildCreate(_ payload: Gateway.GuildCreate) async throws
  func onGuildUpdate(_ payload: Guild) async throws
  func onGuildDelete(_ payload: UnavailableGuild) async throws
  func onGuildBanAdd(_ payload: Gateway.GuildBan) async throws
  func onGuildBanRemove(_ payload: Gateway.GuildBan) async throws
  func onGuildEmojisUpdate(_ payload: Gateway.GuildEmojisUpdate) async throws
  func onGuildStickersUpdate(_ payload: Gateway.GuildStickersUpdate) async throws
  func onGuildIntegrationsUpdate(_ payload: Gateway.GuildIntegrationsUpdate) async throws
  func onGuildMemberAdd(_ payload: Gateway.GuildMemberAdd) async throws
  func onGuildMemberRemove(_ payload: Gateway.GuildMemberRemove) async throws
  func onGuildMemberUpdate(_ payload: Gateway.GuildMemberAdd) async throws
  func onGuildMembersChunk(_ payload: Gateway.GuildMembersChunk) async throws
  func onRequestGuildMembers(_ payload: Gateway.RequestGuildMembers) async throws
  func onGuildRoleCreate(_ payload: Gateway.GuildRole) async throws
  func onGuildRoleUpdate(_ payload: Gateway.GuildRole) async throws
  func onGuildRoleDelete(_ payload: Gateway.GuildRoleDelete) async throws
  func onGuildScheduledEventCreate(_ payload: GuildScheduledEvent) async throws
  func onGuildScheduledEventUpdate(_ payload: GuildScheduledEvent) async throws
  func onGuildScheduledEventDelete(_ payload: GuildScheduledEvent) async throws
  func onGuildScheduledEventUserAdd(_ payload: Gateway.GuildScheduledEventUser) async throws
  func onGuildScheduledEventUserRemove(_ payload: Gateway.GuildScheduledEventUser) async throws
  func onGuildAuditLogEntryCreate(_ payload: AuditLog.Entry) async throws
  func onIntegrationCreate(_ payload: Gateway.IntegrationCreate) async throws
  func onIntegrationUpdate(_ payload: Gateway.IntegrationCreate) async throws
  func onIntegrationDelete(_ payload: Gateway.IntegrationDelete) async throws
  func onInteractionCreate(_ payload: Interaction) async throws
  func onInviteCreate(_ payload: Gateway.InviteCreate) async throws
  func onInviteDelete(_ payload: Gateway.InviteDelete) async throws
  func onMessageCreate(_ payload: Gateway.MessageCreate) async throws
  func onMessageUpdate(_ payload: DiscordChannel.PartialMessage) async throws
  func onMessageDelete(_ payload: Gateway.MessageDelete) async throws
  func onMessageDeleteBulk(_ payload: Gateway.MessageDeleteBulk) async throws
  func onMessageReactionAdd(_ payload: Gateway.MessageReactionAdd) async throws
  func onMessageReactionRemove(_ payload: Gateway.MessageReactionRemove) async throws
  func onMessageReactionRemoveAll(_ payload: Gateway.MessageReactionRemoveAll) async throws
  func onMessageReactionRemoveEmoji(_ payload: Gateway.MessageReactionRemoveEmoji) async throws
  func onPresenceUpdate(_ payload: Gateway.PresenceUpdate) async throws
  func onRequestPresenceUpdate(_ payload: Gateway.Identify.Presence) async throws
  func onStageInstanceCreate(_ payload: StageInstance) async throws
  func onStageInstanceDelete(_ payload: StageInstance) async throws
  func onStageInstanceUpdate(_ payload: StageInstance) async throws
  func onTypingStart(_ payload: Gateway.TypingStart) async throws
  func onUserUpdate(_ payload: DiscordUser) async throws
  func onVoiceStateUpdate(_ payload: VoiceState) async throws
  func onRequestVoiceStateUpdate(_ payload: VoiceStateUpdate) async throws
  func onVoiceServerUpdate(_ payload: Gateway.VoiceServerUpdate) async throws
  func onWebhooksUpdate(_ payload: Gateway.WebhooksUpdate) async throws
  func onApplicationCommandPermissionsUpdate(_ payload: GuildApplicationCommandPermissions) async throws
  func onAutoModerationRuleCreate(_ payload: AutoModerationRule) async throws
  func onAutoModerationRuleUpdate(_ payload: AutoModerationRule) async throws
  func onAutoModerationRuleDelete(_ payload: AutoModerationRule) async throws
  func onAutoModerationActionExecution(_ payload: AutoModerationActionExecution) async throws
  func onMessagePollVoteAdd(_ payload: Gateway.MessagePollVote) async throws
  func onMessagePollVoteRemove(_ payload: Gateway.MessagePollVote) async throws
  
  init(bot: any GatewayManager)
}

// final class DemoExtension: DDBKitExtension {
//  init(bot: any GatewayManager) {
//    self.bot = bot
//  }
//  
//  var bot: any GatewayManager
//  
//  func onMessageCreate(_ payload: Gateway.MessageCreate) async {
//    /// Do what you want
//  }
//  func onInteractionCreate(_ payload: Interaction) async {
//    /// Do what you want
//  }
// }
