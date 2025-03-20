//
//  SoilComponent.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 16/3/25.
//

import GameplayKit

class SoilComponent: GKComponent {
    var quality: Float
    var moisture: Float

    required init?(coder: NSCoder) {
        quality = 0
        moisture = 0
        super.init(coder: coder)
    }

    init(quality: Float, moisture: Float) {
        self.quality = quality
        self.moisture = moisture
        super.init()
    }
}
