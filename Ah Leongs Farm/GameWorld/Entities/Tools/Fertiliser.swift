//
//  Fertiliser.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 30/3/25.
//

import Foundation

class Fertiliser: EntityAdapter, Tool {
    // TODO: Consider FertiliserComponent once we implement fertiliser logic
    let soilImprovementAmount: Float

    init(soilImprovementAmount: Float = 1) {
        self.soilImprovementAmount = soilImprovementAmount
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}

class PremiumFertiliser: Fertiliser {
    override init(soilImprovementAmount: Float = 3) {
        super.init(soilImprovementAmount: soilImprovementAmount)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}
