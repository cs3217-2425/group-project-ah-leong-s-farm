//
//  Fertiliser.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 30/3/25.
//

import Foundation
import GameplayKit

class Fertiliser: GKEntity {
    // TODO: Consider FertiliserComponent once we implement fertiliser logic
    let soilImprovementAmount: Int

    init(soilImprovementAmount: Int = 30) {
        self.soilImprovementAmount = soilImprovementAmount
        super.init()
        setUpComponents()
    }

    func setUpComponents() {
        let itemComponent = ItemComponent(itemType: .fertiliser)
        addComponent(itemComponent)
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

    override func setUpComponents() {
        let itemComponent = ItemComponent(itemType: .premiumFertiliser)
        addComponent(itemComponent)
    }
}
