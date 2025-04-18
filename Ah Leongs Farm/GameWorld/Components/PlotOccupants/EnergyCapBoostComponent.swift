//
//  EnergyCapBoostComponent.swift
//  Ah Leongs Farm
//
//  Created by proglab on 15/4/25.
//

import Foundation

class EnergyCapBoostComponent: ComponentAdapter {

    let type: EnergyType
    let boost: Int

    init(type: EnergyType = EnergyType.base, boost: Int = 1) {
        self.type = type
        self.boost = boost
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}
