//
//  SoilComponent.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 16/3/25.
//

import Foundation

class SoilComponent: ComponentAdapter {
    var quality: Float
    var moisture: Float

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    init(quality: Float, moisture: Float) {
        self.quality = quality
        self.moisture = moisture
        super.init()
    }
}
