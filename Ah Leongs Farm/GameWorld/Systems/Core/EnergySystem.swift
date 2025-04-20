//
//  EnergySystem.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 19/3/25.
//

class EnergySystem: ISystem {
    unowned var manager: EntityManager?

    private var energyBankComponent: EnergyBankComponent? {
        manager?.getSingletonComponent(ofType: EnergyBankComponent.self)
    }

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    @discardableResult
    func useEnergy(of type: EnergyType, amount: Int) -> Bool {
        guard let energyBankComponent = energyBankComponent else {
            return false
        }
        guard energyBankComponent.getCurrentEnergy(of: type) >= amount else {
            return false
        }
        guard amount >= 0 else {
            return false
        }

        let newAmount = energyBankComponent.getCurrentEnergy(of: type) - amount
        energyBankComponent.setCurrentEnergy(of: type, to: newAmount)
        return true
    }

    func replenishEnergy(of type: EnergyType) {
        guard let energyBankComponent = energyBankComponent else {
            return
        }

        energyBankComponent.setCurrentEnergy(of: type, to: energyBankComponent.getMaxEnergy(of: type))
    }

    func increaseMaxEnergy(of type: EnergyType, by amount: Int) {
        guard let energyBankComponent = energyBankComponent else {
            return
        }

        energyBankComponent.setMaxEnergy(of: type, to: energyBankComponent.getMaxEnergy(of: type) + amount)
    }

    func decreaseMaxEnergy(of type: EnergyType, by amount: Int) {
        guard let energyBankComponent = energyBankComponent else {
            return
        }

        energyBankComponent.setMaxEnergy(of: type, to: energyBankComponent.getMaxEnergy(of: type) - amount)
    }

    func getCurrentEnergy(of type: EnergyType) -> Int {
        guard let energyBankComponent = energyBankComponent else {
            return 0
        }
        return energyBankComponent.getCurrentEnergy(of: type)
    }

    func getMaxEnergy(of type: EnergyType) -> Int {
        guard let energyBankComponent = energyBankComponent else {
            return 0
        }
        return energyBankComponent.getMaxEnergy(of: type)
    }

    func getEnergyCapBoostComponents(of type: EnergyType) -> [EnergyCapBoostComponent] {
        manager?.getAllComponents(ofType: EnergyCapBoostComponent.self).filter { $0.type == type } ?? []
    }
}
