//
//  DatabaseModel.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 15/10/2024.
//


import Foundation
import DiscordModels

/// This protocol is required to use `@DatabaseInterface` property wrapper.
/// Types conforming to it can be stored in an interface.
public protocol DatabaseModel: Codable {}
