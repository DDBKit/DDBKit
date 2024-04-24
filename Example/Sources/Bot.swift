// hi mom
import DDBKit
import Foundation
import Database

var botAccount: DiscordUser? = nil

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
  
  struct Count: DatabaseModel {
    var count: Int
  }
  
  var body: [any BotScene] {
    ReadyEvent { data in
      botAccount = data?.user
    }
    
    MessageCreateEvent { msg in
      guard let msg, let guild_id = msg.guild_id else { return }
      let req = Database.FetchRequest.requestFor(guild: guild_id, ofType: Count.self)
      if msg.mentions.contains(where: { $0.id == botAccount?.id }) {
        var count: Int = 0
        print("about to initiate transaction")
        await Database.shared.transaction(req) { obj in
          var obj = obj ?? .init(count: 0)
          obj.count += 1
          count = obj.count
          print("transaction done \(obj.count)")
          return obj
        }
        let _ = try? await bot.client.createMessage(channelId: msg.channel_id, payload: .init(content: "\(count)"))
      }
    }
    
    MessageCreateEvent { msg in
      guard let msg else { return }
      guard msg.channel_id == "1232603619107409960" else { return }
      var req = URLRequest(url: URL(string: "http://127.0.0.1:11434/api/generate")!, timeoutInterval: 360)
      req.httpMethod = "POST"
      let body = """
{"stream":false,
"prompt":"\(msg.content)",
"model":"dt"
}
""".data(using: .utf8)
      do {
        let (data, _) = try await URLSession.shared.data(for: req)
        let dict = data
      } catch {
        print(error)
      }
    }
  }
  
  var bot: Bot
}
