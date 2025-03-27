//
//  SpriteComponent.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 27/3/25.
//

import GameplayKit

class SpriteComponent: GKComponent {
    var textureName: String

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    init(textureName: String) {
        self.textureName = textureName
        super.init()
    }
}
