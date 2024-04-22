//
//  Title.swift
//  
//
//  Created by Lakhan Lothiyi on 22/04/2024.
//

import Foundation

public struct Title: MessageEmbedComponent {
  var text: String
  public init(_ text: String) {
    self.text = text
  }
}
