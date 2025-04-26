//
//  DatabaseModel.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 15/10/2024.
//

import DiscordModels
import Foundation

/// Types conforming to it can be stored on disk.
public protocol DatabaseModel: Codable, Sendable {}
