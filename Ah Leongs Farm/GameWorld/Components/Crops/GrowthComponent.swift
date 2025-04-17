//
//  GrowthComponent.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 25/3/25.
//

import Foundation

class GrowthComponent: ComponentAdapter {
    var totalGrowthTurns: Int
    var currentGrowthTurn: Float = 0
    var canHarvest: Bool {
        currentGrowthTurn >= Float(totalGrowthTurns)
    }

    init(totalGrowthTurns: Int) {
        self.totalGrowthTurns = totalGrowthTurns
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}
