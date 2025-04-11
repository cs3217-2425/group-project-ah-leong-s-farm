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

    init(maxEnergy: Int) {
        self.currentEnergy = maxEnergy
        self.maxEnergy = maxEnergy
        super.init()
    }

}
