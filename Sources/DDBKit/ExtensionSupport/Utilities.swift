//
//  Utilities.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 11/11/2024.
//

@_spi(Extensions)
extension ExtensibleCommand {
  public static func GetExtension<T>(of type: T.Type, from instance: BotInstance) -> T
  where T: DDBKitExtension {
    instance.extensions.first(where: { $0 is T }) as! T  // force unwrap :p
    // heyy if you ended up here, a modifier tried to find its parent extension but it was not found
    // did you forget to register it?
  }
}
