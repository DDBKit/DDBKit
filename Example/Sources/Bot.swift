// hi mom
import DDBKit

@main
struct ExampleBot: DiscordBotApp {
  init() async {
    let http = HTTPClient()
    self.bot = await .init(
      eventLoopGroup: http.eventLoopGroup,
      httpClient: http,
      token: "MTE0NDY2OTI3MDg2MTY4ODkxMw.G9Ux68.nkUhL1VQpfJYKVj2J1ahczq6B-JOj570BZSJvs",
      intents: [.messageContent, .guildMessages]
    )
  }
  
  var bot: Bot
  
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
}
