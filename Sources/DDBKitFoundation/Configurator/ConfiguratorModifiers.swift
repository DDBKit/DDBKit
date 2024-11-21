//
//  ConfiguratorModifiers.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 11/11/2024.
//


@_spi(Extensions) import DDBKit
import DDBKit
import DDBKitUtilities
import Database
import Foundation

public extension ExtensibleCommand {
  // message content builder here
  func furtherReading(@MessageContentBuilder _ paragraph: @escaping () -> [MessageContentComponent]) -> Self {
    self
      .boot { cmd, i in
        let e = Self.GetExtension(of: Configurator.self, from: i)
        let paragraph = paragraph()
          .reduce("") { $0 + $1.textualRepresentation }
          .trimmingCharacters(in: .whitespacesAndNewlines)
        await e.setFurtherReadings(paragraph, for: cmd.baseInfo.name)
      }
  }
}
