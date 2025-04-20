//
//  GrowthComponent.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 25/3/25.
//

import Foundation

class GrowthComponent: ComponentAdapter {
    let totalGrowthTurns: Int
    let totalGrowthStages: Int
    var currentGrowthTurn: Float = 0
    var currentGrowthStage: Int {
        let growthProgress = min(currentGrowthTurn / Float(totalGrowthTurns), 1.0)
        return Int(growthProgress * Float(totalGrowthStages))
    }

    var canHarvest: Bool {
        currentGrowthTurn >= Float(totalGrowthTurns)
    }

    init(totalGrowthTurns: Int, totalGrowthStages: Int) {
        self.totalGrowthTurns = totalGrowthTurns
        self.totalGrowthStages = totalGrowthStages
        super.init()
    }

    init(totalGrowthTurns: Int, totalGrowthStages: Int, currentGrowthTurn: Float) {
        self.totalGrowthTurns = max(0, totalGrowthTurns)
        self.currentGrowthTurn = min(currentGrowthTurn, Float(self.totalGrowthTurns))
        self.totalGrowthStages = totalGrowthStages
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}
