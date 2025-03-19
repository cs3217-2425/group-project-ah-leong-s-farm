//
//  EnergyComponent.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 19/3/25.
//

import GameplayKit

class EnergyComponent: GKComponent {
    var currentEnergy: Int
    var maxEnergy: Int

    required init?(coder: NSCoder) {
        currentEnergy = 10
        maxEnergy = 10
        super.init(coder: coder)
    }

    init(maxEnergy: Int) {
        self.currentEnergy = maxEnergy
        self.maxEnergy = maxEnergy
        super.init()
    }

}
