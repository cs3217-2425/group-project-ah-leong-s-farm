//
//  Crop.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 27/3/25.
//

import Foundation
import GameplayKit

protocol Crop: SpriteRenderManagerVisitor where Self: GKEntity {
    var seedItemType: ItemType { get }
    var harvestedItemType: ItemType { get }
    var components: [GKComponent] { get }
    static func createSeed() -> GKEntity
    static func createHarvested() -> GKEntity
}
