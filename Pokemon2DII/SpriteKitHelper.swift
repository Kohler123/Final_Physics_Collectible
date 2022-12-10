//
//  SpriteKitHelper.swift
//  Pokemon2DII
//
//  Created by Logan McMahon on 12/8/22.
//

import Foundation
import SpriteKit

enum Layer:CGFloat{
    case background
    case player
    case pokemon
}

enum PhysicsCategory{
    static let none: UInt32 = 0
    static let player: UInt32 = 0b1
    static let pokemon: UInt32 = 0b10
}
