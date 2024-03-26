//
//  Bot.swift
//  DDBKitExample
//
//  Created by Lakhan Lothiyi on 22/03/2024.
//

import DDBKit

@main
struct egg: DiscordBotApp {
  init() async {
    let httpClient = HTTPClient()
    // Edit this as needed.
    bot = await BotGatewayManager(
      eventLoopGroup: httpClient.eventLoopGroup,
      httpClient: httpClient,
      token: "MTE0NDY2OTI3MDg2MTY4ODkxMw.G9Ux68.nkUhL1VQpfJYKVj2J1ahczq6B-JOj570BZSJvs",
//      token: "gm",
      largeThreshold: 250,
      presence: .init(activities: [], status: .online, afk: false),
      intents: [.messageContent, .guildMessages]
    )
  }
  
  var body: [any BotScene] {
    Event(on: .ready) { data in
      let ready = data?.asType(Gateway.Ready.self)
      print("\(ready?.user.username ?? "") is gaming in \(ready?.guilds.count ?? 0) servers fr")
    }
    
    Event(on: .messageCreate) { data in
      let msg = data?.asType(Gateway.MessageCreate.self)
      if let msg {
        print("[\(msg.author?.username ?? "unknown")] \(msg.content)")
      }
    }
  }
  
  var bot: Bot
}

//@main
//struct MyNewBot: DiscordBotApp {
//  init() async {
//    let httpClient = HTTPClient()
//    // Edit this as needed.
//    bot = await BotGatewayManager(
//      eventLoopGroup: httpClient.eventLoopGroup,
//      httpClient: httpClient,
//      token: "Token Here",
//      largeThreshold: 250,
//      presence: .init(activities: [], status: .online, afk: false),
//      intents: [.messageContent, .guildMessages]
//    )
//  }
//  
//  var bot: DiscordGateway.BotGatewayManager
//  
//  var body: some BotScene {
//    /// Receives the ready payload from Discord containing lots of bot data.
//    Event(on: .ready) { payload in
//      print("hi mom, i'm \(payload.user.username)")
//    }
//    
//    Command("ping") { interaction in
//      interaction.reply("Pong!") /// Replacement for `interaction.reply(Message(content: "Pong"))`, as String conforms to DiscordMessageConvertible
//    }
//    
//    ContextMenu("admin-option", displayName: "Admin Option", on: .message) { interaction in
//      // do nothing
//    }
//    .requiresPermission(.admin)
//    
//    ContextMenu("party-poppers", displayName: "Party Poppers!", on: .message) { interaction in
//      let msg = Message(content: "")
//        .embeds {
//          Embed(
//            title: "🎉",
//            description: "Have a party popper!",
//            color: .red
//          )
//        }
//      interaction.channel!.reply(msg)
//      interaction.reply("Party poppers delivered!", ephemeral: true)
//    }
//    .requiresPermission(.manageMessages)
//    
//    CommandGroup("user") {
//      Command("kick") { /* ... */ }
//      Command("ban") { /* ... */ }
//      Command("timeout") { /* ... */ }
//    }
//  }
//}

//import DiscordBM
//import AsyncHTTPClient
//
//@main
//struct Bot {
//  static let httpClient = HTTPClient()
//  static let token = "MTE0NDY2OTI3MDg2MTY4ODkxMw.G9Ux68.nkUhL1VQpfJYKVj2J1ahczq6B-JOj570BZSJvs"
//  static func main() async {
//    let bot = await BotGatewayManager(
//      eventLoopGroup: httpClient.eventLoopGroup,
//      httpClient: httpClient,
//      token: token,
//      presence: .init( /// Set up bot's initial presence
//        /// Will show up as "Playing Fortnite"
//        activities: [.init(name: "Xcode", type: .game)],
//        status: .online,
//        afk: false
//                     ),
//      /// Add all the intents you want
//      /// You can also use `Gateway.Intent.unprivileged` or `Gateway.Intent.allCases`
//      intents: Gateway.Intent.allCases
//    )
//    
//    await bot.connect()
//    
//    for await event in await bot.events {
//      EventHandler(event: event, client: bot.client).handle()
//    }
//    
//  }
//}
//
//struct EventHandler: GatewayEventHandler {
//  let event: Gateway.Event
//  let client: any DiscordClient
//  
//  func onReady(_ payload: Gateway.Ready) async throws {
////    let guilds = try await client.listOwnGuilds().decode()
////    let guildId = guilds.first!.id
////    let guild = try await client.getGuild(id: guildId, withCounts: true).decode()
////    print(guild)
//  }
//  
//  func onMessageCreate(_ payload: Gateway.MessageCreate) async throws {
//    print("[\(payload.author?.username ?? "User")] \(payload.content)")
//  }
//  
//  func onInteractionCreate(_ payload: Interaction) async throws {
//    let id = payload.channel!.id
//  }
//}
