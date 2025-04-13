//
//  Fertiliser.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 30/3/25.
//

import Foundation

class Fertiliser: EntityAdapter {
    // TODO: Consider FertiliserComponent once we implement fertiliser logic
    let soilImprovementAmount: Int

    init(soilImprovementAmount: Int = 30) {
        self.soilImprovementAmount = soilImprovementAmount
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}

class PremiumFertiliser: Fertiliser {
    override init(soilImprovementAmount: Int = 100) {
        super.init(soilImprovementAmount: soilImprovementAmount)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}
