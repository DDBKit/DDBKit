//
//  ExampleExtension.swift
//  ExampleBot
//
//  Created by Lakhan Lothiyi on 07/11/2024.
//

@_spi(Extensions) import DDBKit
import DDBKit


struct PrintAllCommandsExtension: DDBKitExtension {
  func onBoot(_ instance: inout BotInstance) async throws {
    let registeredCommands = instance.commands.map(\.baseInfo.name)
    print(registeredCommands)
  }
}

extension ExtensibleCommand {
  func logUsages() -> Self {
    self
//      .boot { cmd, _ in
//        print("\(cmd.baseInfo.name) command exists!")
//      }
//      .catchAction { error, cmd, _, _, i, _ in
//        print("\(cmd.baseInfo.name) command errored for \(i.member?.user?.username ?? "unknown user") with error: \(error)")
//      }
//      .preAction { cmd, _, _, i, _ in
//        print("\(cmd.baseInfo.name) command started by \(i.member?.user?.username ?? "unknown user")")
//      }
//      .postAction { cmd, _, _, i, _ in
//        print("\(cmd.baseInfo.name) command completed for \(i.member?.user?.username ?? "unknown user")")
//      }
  }
}
