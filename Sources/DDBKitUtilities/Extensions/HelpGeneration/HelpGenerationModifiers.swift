//
//  HelpGenerationModifiers.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 06/05/2025.
//

@_spi(Extensions) import DDBKit
import Foundation

extension ExtensibleCommand {
  // message content builder here
  public func furtherReading(
    @MessageContentBuilder _ paragraph: @Sendable @escaping () -> [MessageContentComponent]
  ) -> Self {
    self
      .boot { cmd, i in
        let e = Self.GetExtension(of: HelpGeneration.self, from: i)
        let paragraph = paragraph()
          .reduce("") { $0 + $1.textualRepresentation }
          .trimmingCharacters(in: .whitespacesAndNewlines)
        await e.setFurtherReadings(for: self.baseInfo.name, paragraph)
      }
  }
}
