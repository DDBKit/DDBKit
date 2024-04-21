//
//  MessageContent.swift
//  
//
//  Created by Lakhan Lothiyi on 19/04/2024.
//

import Foundation

@resultBuilder
public struct MessageUtilityBuilder<T> {
  public static func buildBlock(_ components: T...) -> [T] { components }
}

public protocol MessageContentComponent {
  var textualRepresentation: String { get }
}
