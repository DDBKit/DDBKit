// hi mom
import DDBKit
@_spi(Extensions) import DDBKitFoundation
import DDBKitUtilities
import Foundation

@main
struct MyNewBot: DiscordBotApp {
  init() async {
    // Edit below as needed.
    bot = await BotGatewayManager(
      /// Need sharding? Use `ShardingGatewayManager`
      /// Do not store your token in your code in production.
      token: token,
      /// replace the above with your own token, but only for testing
      intents: [.messageContent, .guildMessages]
    )
    // Will be useful
    cache = await .init(
      gatewayManager: bot,
      intents: .all,  // it's better to minimise cached data to your needs
      requestAllMembers: .enabledWithPresences,
      messageCachingPolicy: .saveEditHistoryAndDeleted
    )
  }

  func onBoot() async throws {
    // Register extensions
    RegisterExtension(BucketRatelimiting())
    RegisterExtension(HelpGeneration())

    AssignGlobalCatch { error, interaction in
      // handle errors thrown from commands etc
      do {
        try await interaction.respond {
          Message {
            MessageEmbed {
              Title("Your interaction ran into a problem")
              Description {
                Text(error.localizedDescription)
                Codeblock("\(error)", lang: "swift")
              }
            }
            .setColor(.red)
          }
        }
      } catch (_) {
        print("Failed to send error message, source error:\n\(error)")
      }
    }
  }

  var body: [any BotScene] {
    Command("ping") { interaction in
      try await interaction.respond {
        Message {
          Text("Pong!")
        }
        //				.ephemeral()
      }
    }
    .integrationType(.all, contexts: .all)
    .description("Ping the bot.")
    .ratelimited()

    Commands
    #if !os(Linux)
      Manipulation
    #endif

    SystemStatistics

    //		Command("test1") { interaction in }
    //		Command("test2") { interaction in }
    //		Command("test3") { interaction in }
    //		Command("test4") { interaction in }
    //		Command("test5") { interaction in }
    //		Command("test6") { interaction in }
    //		Command("test7") { interaction in }
    //		Command("test8") { interaction in }
    //		Command("test9") { interaction in }
    //		Command("test10") { interaction in }
    //		Command("test11") { interaction in }
    //		Command("test12") { interaction in }
    //		Command("test13") { interaction in }
    //		Command("test14") { interaction in }
    //		Command("test15") { interaction in }
    //		Command("test16") { interaction in }
  }

  var bot: Bot
  var cache: Cache
}

extension String: @retroactive LocalizedError {}
