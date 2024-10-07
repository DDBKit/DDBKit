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
    
    manipulation
    
    coremlCommands
    
    SubcommandBase("mod") {
      SubcommandGroup("info") {
        Subcommand("server") { int, cmd, reqs in
          print("true")
          guard let id = int.guild_id, let guild = try? await bot.client.getGuild(id: id, withCounts: true).decode() else { return }
          
          let icon: String? = {
            if let icon = guild.icon {
              return CDNEndpoint.guildIcon(guildId: guild.id, icon: icon).url.appending("?size=1024")
            }
            return nil
          }()
          let banner: String? = {
            if let banner = guild.banner {
              return CDNEndpoint.guildBanner(guildId: guild.id, banner: banner).url.appending("?size=1024")
            }
            return nil
          }()
          
          try? await bot.createInteractionResponse(to: int) {
            Message {
              MessageEmbed {
                Title(guild.name)
                if let icon {
                  Thumbnail(.exact(icon))
                }
                if let banner {
                  Image(.exact(banner))
                }
                
                Field("**wagwan**", "hiii")
                  .inline()
                Field("meow") {
                  Text(":3")
                    .bold()
                }
                .inline()
                
                Footer("🟢 \(guild.approximate_presence_count ?? 0) online | \(guild.approximate_member_count ?? 0) members")
              }
            }
          }
        }
        
        Subcommand("user") { int, cmd, reqs in
          // ...
        }
      }
      
      Subcommand("kick") { int, cmd, reqs in
        // ...
      }
      
      Subcommand("ban") { int, cmd, reqs in
        // ...
      }
    }
  }
  
  var bot: Bot
  var cache: Cache
}
