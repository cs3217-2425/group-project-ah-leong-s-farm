//
//  SpriteComponent.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 27/3/25.
//

import Foundation

class SpriteComponent: ComponentAdapter {
    let spriteRenderManagerVisitor: SpriteRenderManagerVisitor
    let spriteRenderManagerUpdateVisitor: SpriteRenderManagerUpdateVisitor?

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    init(visitor: SpriteRenderManagerVisitor,
         updateVisitor: SpriteRenderManagerUpdateVisitor? = nil) {
        self.spriteRenderManagerVisitor = visitor
        self.spriteRenderManagerUpdateVisitor = updateVisitor
        super.init()
    }
}
