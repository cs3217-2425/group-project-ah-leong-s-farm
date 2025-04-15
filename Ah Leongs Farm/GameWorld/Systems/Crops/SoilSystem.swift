//
//  SoilSystem.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 15/4/25.
//

import Foundation
class SoilSystem: ISystem {
    unowned var manager: EntityManager?

    private let soilDegradationRate: Float = 0.05
    private let minimumSoilQuality: Float = 0.2
    private let defaultSoilQuality: Float = 1.0

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    func degradeSoilQuality() {
        let soilComponents = manager?.getAllComponents(ofType: SoilComponent.self) ?? []

        for soilComponent in soilComponents {
            let newQuality = max(soilComponent.quality - soilDegradationRate, minimumSoilQuality)
            soilComponent.quality = newQuality
        }
    }

    func improveSoilQuality(plot: Plot, improvementAmount: Float) -> Bool {
        guard let soilComponent = plot.getComponentByType(ofType: SoilComponent.self) else {
            return false
        }

        let maxSoilQuality: Float = 3.0
        soilComponent.quality = min(soilComponent.quality + improvementAmount, maxSoilQuality)

        return true
    }

    func getSoilQuality(plot: Plot) -> Float? {
        guard let soilComponent = plot.getComponentByType(ofType: SoilComponent.self) else {
            return nil
        }

        return soilComponent.quality
    }
}
