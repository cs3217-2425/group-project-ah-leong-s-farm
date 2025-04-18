//
//  EnergyBankComponent.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 19/3/25.
//

import Foundation

class EnergyBankComponent: ComponentAdapter {
    var energyBank: [EnergyType: EnergyStat]

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    init(initialEnergies: [EnergyType: EnergyStat] = [.base: EnergyStat(current: 10, max: 10)]) {
        self.energyBank = initialEnergies
        super.init()
    }

    func setCurrentEnergy(of type: EnergyType, to value: Int) {
        if var stat = energyBank[type] {
            stat.current = value
            energyBank[type] = stat
        }
    }

    func setMaxEnergy(of type: EnergyType, to value: Int) {
        if var stat = energyBank[type] {
            stat.max = value
            energyBank[type] = stat
        }
    }

    func getCurrentEnergy(of type: EnergyType) -> Int {
        guard let stat = energyBank[type] else {
            return 0
        }

        return stat.current
    }

    func getMaxEnergy(of type: EnergyType) -> Int {
        guard let stat = energyBank[type] else {
            return 0
        }

        return stat.max
    }

    func increaseMaxEnergy(of type: EnergyType, by amount: Int) {
        if var stat = energyBank[type] {
            let newAmount = stat.max + amount
            stat.max = newAmount
            energyBank[type] = stat
        }
    }
}

enum EnergyType {
    case base
}
