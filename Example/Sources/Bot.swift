// hi mom
import DDBKit
import DDBKitUtilities

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
  
  func boot() async throws {
    // register stuff
//    RegisterExtension(<#any DDBKitExtension#>)
    AssignGlobalCatch { bot, error, i in
      try await bot.createInteractionResponse(to: i) {
        Message {
          MessageEmbed {
            Title("Your command ran into a problem")
            Description {
              Text(error.localizedDescription)
              Text("\n\n")
              Codeblock("\(error)", lang: "swift")
            }
          }
          .setColor(.red)
        }
      }
    }
  }
  
  var body: [any BotScene] {
    ReadyEvent { _ in print("hi mom") }
    
    Commands
    #if !os(Linux)
    manipulation
    coremlCommands
    #endif
    
    Command("failable") { i, _, _ in
      throw "This command failed oh no who could've guessed"
    }
  }
  
  var bot: Bot
  var cache: Cache
}
import Foundation
extension String: @retroactive LocalizedError {
  public var errorDescription: String? { self }
}
