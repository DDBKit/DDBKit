// hi mom
import DDBKit
import DDBKitUtilities
import Foundation
import Database

import DDBKitFoundation

@main
struct MyNewBot: DiscordBotApp {
  init() async {
    // Edit below as needed.
    bot = await BotGatewayManager( /// Need sharding? Use `ShardingGatewayManager`
      /// Do not store your token in your code in production.
      token: token,
      /// replace the above with your own token, but only for testing
      presence: .init(activities: [], status: .online, afk: false),
      intents: [.messageContent, .guildMessages]
    )
    // Will be useful
    cache = await .init(
      gatewayManager: bot,
      intents: .all, // it's better to minimise cached data to your needs
      requestAllMembers: .enabledWithPresences,
      messageCachingPolicy: .saveEditHistoryAndDeleted
    )
  }
  
  var body: [any BotScene] {
    ReadyEvent { _ in print("hi mom") }
    
    Commands
    Events
    #if !os(Linux)
    manipulation
    coremlCommands
    #endif
    
    Context("meow at this message", kind: .message) { i, _, _ in
      try? await bot.createInteractionResponse(to: i) {
        Message {
          MessageContent {
            Text("Redacted")
          }
          
          MessageEmbed {
            Title("wagwan")
            Description("Please take a shower immediately")
            
            Field("egg", "nog").inline()
            Field("egg", "nog").inline()
            Field("egg", "nog").inline()
            Field("egg", "nog").inline()
          }
          .setColor(.green)
          .setTimestamp()
        }
      }
    }
    .integrationType(.all, contexts: .all)
    
    Command("egg") { i, _, _ in
      try? await bot.createInteractionResponse(to: i) {
        Message {
          MessageContent {
            Text("this chat is smelly")
          }
          
          MessagePoll(emoji: .id("1295897627505987634"), hours: 1) {
            PollAnswer(emoji: .id("1295877525154566156"))
            PollAnswer(emoji: .id("1295897627505987634"))
          }
          .allowMultipleAnswers()
        }
      }
    }
    .integrationType(.all, contexts: .all)
  }
  
  var bot: Bot
  var cache: Cache
}
