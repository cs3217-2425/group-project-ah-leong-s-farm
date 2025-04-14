//
//  EnergyComponent.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 19/3/25.
//

import Foundation

class EnergyComponent: ComponentAdapter {
    var currentEnergy: Int
    var maxEnergy: Int

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    init(currentEnergy: Int, maxEnergy: Int) {
        self.currentEnergy = currentEnergy
        self.maxEnergy = maxEnergy
        super.init()
    }

    convenience init(maxEnergy: Int) {
        self.init(currentEnergy: maxEnergy, maxEnergy: maxEnergy)
    }

}
