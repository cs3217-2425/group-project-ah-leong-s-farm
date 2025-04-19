//
//  UpgradeSystem.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 16/4/25.
//

class UpgradeSystem: ISystem {
    unowned var manager: EntityManager?

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    private var upgradeComponent: UpgradeComponent? {
        manager?.getSingletonComponent(ofType: UpgradeComponent.self)
    }

    func getUpgradePoints() -> Int {
        upgradeComponent?.points ?? 0
    }

    func addUpgradePoint(_ pointsToAdd: Int = 1) {
        guard let upgradeComponent = upgradeComponent else {
            return
        }
        upgradeComponent.points += pointsToAdd
    }

    @discardableResult
    func useUpgradePoint(_ pointsToUse: Int = 1) -> Bool {
        guard let upgradeComponent = upgradeComponent,
                  upgradeComponent.points - pointsToUse >= 0 else {
            return false
        }
        upgradeComponent.points -= pointsToUse
        return true
    }
}
