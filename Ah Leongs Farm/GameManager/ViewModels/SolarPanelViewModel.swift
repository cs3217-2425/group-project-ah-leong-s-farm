//
//  SolarPanelViewModel.swift
//  Ah Leongs Farm
//
//  Created by proglab on 17/4/25.
//

struct SolarPanelViewModel: PlotOccupantViewModel {
    let boost: Int

    init?(solarPanel: SolarPanel) {
        guard let energyCapBoostComponent = solarPanel.getComponentByType(ofType: EnergyCapBoostComponent.self) else {
            return nil
        }
        self.boost = energyCapBoostComponent.boost
    }
}
