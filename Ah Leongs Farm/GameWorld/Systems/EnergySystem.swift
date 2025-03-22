//
//  EnergySystem.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 19/3/25.
//

import GameplayKit

class EnergySystem: GKComponentSystem<EnergyComponent> {

    override init() {
        super.init(componentClass: EnergyComponent.self)
    }

    func useEnergy(amount: Int) -> Bool {
        guard let energyComponent = components.first else {
            return false
        }
        guard energyComponent.currentEnergy >= amount else {
            return false
        }
        guard amount >= 0 else {
            return false
        }

        energyComponent.currentEnergy -= amount
        return true
    }

    func replenishEnergy() {
        guard let energyComponent = components.first else {
            return
        }
        energyComponent.currentEnergy = energyComponent.maxEnergy
    }

    func increaseMaxEnergy(by amount: Int) {
        guard let energyComponent = components.first else {
            return
        }
        energyComponent.maxEnergy += amount
    }

    func getCurrentEnergy() -> Int {
        guard let turnComponent = components.first else {
            return 0
        }
        return turnComponent.currentEnergy
    }

    func getMaxEnergy() -> Int {
        guard let turnComponent = components.first else {
            return 0
        }
        return turnComponent.maxEnergy
    }

}
