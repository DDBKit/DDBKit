//
//  PermissionsExtension.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 13/05/2025.
//

@_spi(Extensions) import DDBKit
import Foundation

actor PermissionsExtension: DDBKitExtension {
  func onBoot(_ instance: inout BotInstance) async throws {
    print("hi mom")
  }
}
