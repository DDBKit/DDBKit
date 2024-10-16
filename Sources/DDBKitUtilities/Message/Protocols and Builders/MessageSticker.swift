//
//  Sticker.swift
//  DDBKit
//
//  Created by paige on 10/15/24.
//

/// A representation of a sticker within a message.
///
/// Note that stickers have a limit of 3 and stickers
/// are not supported in interaction responses
public struct MessageSticker: MessageComponent {
  public var id: String
  public init(_ id: String) {
    self.id = id
  }
}
