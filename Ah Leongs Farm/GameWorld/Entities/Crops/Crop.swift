//
//  Crop.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 27/3/25.
//

import Foundation
import GameplayKit

protocol Crop: SpriteRenderManagerVisitor where Self: EntityAdapter {
    var seedItemType: ItemType { get }
    var harvestedItemType: ItemType { get }
    static func createSeed() -> Entity
    static func createHarvested() -> Entity
}
