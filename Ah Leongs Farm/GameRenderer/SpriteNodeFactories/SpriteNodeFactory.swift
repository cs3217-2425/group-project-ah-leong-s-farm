//
//  SKSpriteNodeFactory.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 30/3/25.
//

import SpriteKit

protocol SpriteNodeFactory {
    associatedtype T: SpriteNode

    func createNode(for: EntityType, textureName: String) -> T?
}
