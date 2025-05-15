//
//  PermissionsExtension.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 13/05/2025.
//

import Foundation
@_spi(Extensions) import DDBKit

actor PermissionsExtension: DDBKitExtension {
	func onBoot(_ instance: inout BotInstance) async throws {
		print("hi mom")
	}
}
