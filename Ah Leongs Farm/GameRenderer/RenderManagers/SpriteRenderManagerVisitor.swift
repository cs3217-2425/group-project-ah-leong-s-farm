//
//  SpriteRenderManagerVisitor.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 1/4/25.
//

protocol SpriteRenderManagerVisitor {
    func visit(manager: SpriteRenderManager, renderer: GameRenderer)
}
