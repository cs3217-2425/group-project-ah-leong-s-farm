//
//  IRenderNode.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 30/3/25.
//

import SpriteKit

protocol IRenderNode where Self: SKNode {
    var handler: InteractionHandler? { get set }
}
