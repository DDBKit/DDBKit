//
//  MiscUtils.swift
//  ExampleBot
//
//  Created by Lakhan Lothiyi on 07/10/2024.
//

import DiscordBM

enum MiscUtils { }

extension MiscUtils {
  static func getUserID(from int: Interaction) -> UserSnowflake? {
    int.member?.user?.id ?? int.user?.id ?? int.message?.author?.id
  }
}
