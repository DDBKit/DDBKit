//
//  ExampleExtension.swift
//  ExampleBot
//
//  Created by Lakhan Lothiyi on 07/11/2024.
//

@_spi(Extensions) import DDBKit
import DDBKit

actor ExampleExtension: DDBKitExtension {
  
  func onBoot(_ instance: inout BotInstance) async throws {
    // makes every command log its name when executed
    instance.commands = instance.commands.map { cmd in
      cmd
        .preAction { cmd, _ in
          print(cmd.baseInfo.name)
        }
        .postAction { cmd, _ in
          print(cmd.baseInfo.name, "finished") // if it didnt error this will work
        }
    }
  }
  
  func register() -> [any BotScene] {
    Command("gm") { e in
      try await e.respond(with: "gm")
    }
  }
  
  func onEvent(_ instance: BotInstance, event: Gateway.Event) async throws {
    if let type = event.type {
      print(type, "received")
    }
    MessageReceiveHandle(event: event).handle()
  }
  
  struct MessageReceiveHandle: GatewayEventHandler {
    var event: Gateway.Event
    
    func onMessageCreate(_ payload: Gateway.MessageCreate) async throws {
      print("[\(payload.author?.username ?? "idk")] \(payload.content)")
    }
  }
}
