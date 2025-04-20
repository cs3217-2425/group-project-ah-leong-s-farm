//
//  SpriteRenderManagerVisitor.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 1/4/25.
//

protocol SpriteRenderManagerVisitor {
    func createNode(manager: SpriteRenderManager, renderer: GameRenderer)
}

protocol SpriteRenderManagerUpdateVisitor {
    func transformNode(_ node: any IRenderNode, manager: SpriteRenderManager, renderer: GameRenderer)
}
