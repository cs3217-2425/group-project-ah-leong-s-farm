//
//  PlotEntity.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 13/3/25.
//

import GameplayKit

class Plot: GKEntity {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addComponent(PositionComponent(x: 0, y: 0))
    }

    init(x: CGFloat, y: CGFloat) {
        super.init()
        addComponent(PositionComponent(x: x, y: y))
    }

    
}
