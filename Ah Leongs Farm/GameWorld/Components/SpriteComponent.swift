//
//  SpriteComponent.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 27/3/25.
//

import GameplayKit

class SpriteComponent: GKComponent {
    let spriteRenderManagerVisitor: SpriteRenderManagerVisitor

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    init(visitor: SpriteRenderManagerVisitor) {
        self.spriteRenderManagerVisitor = visitor
        super.init()
    }
}
