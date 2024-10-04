//
//  TestEvents.swift
//  ExampleBot
//
//  Created by Lakhan Lothiyi on 04/10/2024.
//

import DDBKit

extension MyNewBot {
  var Events: Group {
    Group {
      MessageCreateEvent { msg in
        print("[\(msg!.author!.username)] \(msg!.content)")
      }
    }
  }
}
