// hi mom
import DDBKit

@main
struct MyNewBot: DiscordBotApp {
  init() async {
    let httpClient = HTTPClient()
    // Edit this as needed.
    bot = await BotGatewayManager(
      eventLoopGroup: httpClient.eventLoopGroup,
      httpClient: httpClient,
      /// Do not store your token in your code in production.
      token: token,
      /// replace the above with your own token, but only for testing
      largeThreshold: 250,
      presence: .init(activities: [], status: .online, afk: false),
      intents: [.messageContent, .guildMessages]
    )
  }
  
  var body: [any BotScene] {
    ReadyEvent { ready in
      print("hi mom")
    }
    
    MessageCreateEvent { msg in
      if let msg {
        print("[\(msg.author?.username ?? "unknown")] \(msg.content)")
        
        if msg.content == "!gm" && ["llsc12", "tobias112", "james.op", "deckyboiii"].contains(msg.author?.username) {
          let a = Message {
            MessageContent {
              Heading {
                Text {
                  Text("Welcome to ")
                  Text("The Test")
                    .italic()
                  Text("!")
                }
                .underlined()
              }
              Heading("We're testing the Message DSL")
                .medium()
              Text("Actually scratch that")
                .strikethrough()
              NewLine()
              URL("https://llsc12.me")
                .disableLinking()
                .maskedWith {
                  Text("check out this!")
                    .bold()
                }
            }
          }
          
          let _ = try? await bot.client.createMessage(
            channelId: msg.channel_id,
            payload: .init(
              content: a.content.textualRepresentation
            )
          )
        }
      }
    }
  }
  
  var bot: Bot
}

import SwiftUI

class egg {
  @State var egg = false
}
