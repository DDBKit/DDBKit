//
//  ExampleExtension.swift
//  ExampleBot
//
//  Created by Lakhan Lothiyi on 07/11/2024.
//

@_spi(Extensions) import DDBKit
struct ExampleExtension: DDBKitExtension {
  func onBoot(_ instance: inout BotInstance) async throws {
    instance.commands = instance.commands.map {
      var cmd = $0 as! ExtensibleCommand
      cmd.preActions.append { _,_,_,_,_ in
        print("Pre action")
      }
      return cmd as! BaseContextCommand
    }
  }
}
