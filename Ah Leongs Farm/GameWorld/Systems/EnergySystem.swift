//
//  EnergySystem.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 19/3/25.
//

class EnergySystem: ISystem {
    unowned var manager: EntityManager?

    private var energyComponent: EnergyComponent? {
        manager?.getSingletonComponent(ofType: EnergyComponent.self)
    }

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    @discardableResult
    func useEnergy(amount: Int) -> Bool {
        guard let energyComponent = energyComponent else {
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
        guard let energyComponent = energyComponent else {
            return
        }
        energyComponent.currentEnergy = energyComponent.maxEnergy
    }

    func increaseMaxEnergy(by amount: Int) {
        guard let energyComponent = energyComponent else {
            return
        }
        energyComponent.maxEnergy += amount
    }

    func getCurrentEnergy() -> Int {
        guard let energyComponent = energyComponent else {
            return 0
        }
        return energyComponent.currentEnergy
    }

    func getMaxEnergy() -> Int {
        guard let energyComponent = energyComponent else {
            return 0
        }
        return energyComponent.maxEnergy
    }
}
