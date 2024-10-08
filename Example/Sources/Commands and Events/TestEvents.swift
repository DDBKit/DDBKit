//
//  TestEvents.swift
//  ExampleBot
//
//  Created by Lakhan Lothiyi on 04/10/2024.
//

import DDBKit
import DDBKitUtilities

extension MyNewBot {
  var Events: Group {
    Group {
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
            try? await bot.createInteractionResponse(to: int) {
              Message { Text("Unimplemented") }
            }
          }
        }
        
        Subcommand("kick") { int, cmd, reqs in
          try? await bot.createInteractionResponse(to: int) {
            Message { Text("Unimplemented") }
          }
        }
        
        Subcommand("ban") { int, cmd, reqs in
          try? await bot.createInteractionResponse(to: int) {
            Message { Text("Unimplemented") }
          }
        }
      }

    }
  }
}
