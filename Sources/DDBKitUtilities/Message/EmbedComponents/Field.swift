//
//  Field.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 07/10/2024.
//

import DiscordBM

public struct Field: MessageEmbedComponent {
  var field: Embed.Field
  public init(
    _ name: @autoclosure () -> MessageContentComponent,
    _ value: @autoclosure () -> MessageContentComponent
  ) {
    self.field = .init(
      name: name().textualRepresentation,
      value: value().textualRepresentation,
      inline: nil
    )
  }

  public init(
    _ name: @autoclosure () -> MessageContentComponent,
    @MessageContentBuilder _ value: () -> [MessageContentComponent]
  ) {
    self.field = .init(
      name: name().textualRepresentation,
      value: value().reduce("") { $0 + $1.textualRepresentation }.trimmingCharacters(
        in: .whitespacesAndNewlines),
      inline: nil
    )
  }
}

extension Field {
  public func inline(_ bool: Bool = true) -> Self {
    var copy = self
    copy.field.inline = bool
    return copy
  }
}
