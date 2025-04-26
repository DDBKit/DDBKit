//
//  MessageAttachment.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 25/09/2024.
//

import Foundation
import NIOCore

/// Interface to making attachments
public struct MessageAttachment: MessageComponent {
  var data: ByteBuffer
  var filename: String
  var description: String?
  var ephemeral: Bool = false

  var use: UseCase = .attachment

  public init(_ data: Data, filename: String) {
    self.data = .init(data: data)
    self.filename = filename
  }

  public init(_ data: ByteBuffer, filename: String) {
    self.data = data
    self.filename = filename
  }

  public enum UseCase: Sendable {
    case attachment
    case embed
  }
}

extension MessageAttachment {
  public func description(_ str: String) -> Self {
    var copy = self
    copy.description = str
    return copy
  }

  public func ephemeral(_ bool: Bool) -> Self {
    var copy = self
    copy.ephemeral = bool
    return copy
  }

  /// If you want to use a file in an embed, set this to `.embed`
  public func usage(_ type: UseCase) -> Self {
    var copy = self
    copy.use = type
    return copy
  }
}
