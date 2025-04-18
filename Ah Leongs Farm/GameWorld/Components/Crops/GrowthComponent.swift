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
    var currentGrowthStage: Int = 0

    var canHarvest: Bool {
        currentGrowthTurn >= Float(totalGrowthTurns)
    }

    var growthProgress: Float {
        min(currentGrowthTurn / Float(totalGrowthTurns), 1.0)
    }

    func updateGrowthStage() -> Bool {
        let previousStage = currentGrowthStage
        currentGrowthStage = Int(growthProgress * Float(totalGrowthStages))
        return previousStage != currentGrowthStage
    }

    init(totalGrowthTurns: Int, totalGrowthStages: Int) {
        self.totalGrowthTurns = totalGrowthTurns
        self.totalGrowthStages = totalGrowthStages
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}
