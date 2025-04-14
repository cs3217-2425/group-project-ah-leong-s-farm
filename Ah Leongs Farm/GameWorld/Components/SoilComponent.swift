//
//  SoilComponent.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 16/3/25.
//

import Foundation

class SoilComponent: ComponentAdapter {
    var quality: Float
    var hasWater: Bool

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    init(quality: Float, hasWater: Bool) {
        self.quality = quality
        self.hasWater = hasWater
        super.init()
    }
}
