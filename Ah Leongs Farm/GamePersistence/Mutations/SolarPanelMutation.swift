//
//  SolarPanelMutation.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 19/4/25.
//

import Foundation

protocol SolarPanelMutation {
    func upsertSolarPanel(sessionId: UUID, id: UUID, solarPanel: SolarPanel) -> Bool

    func deleteSolarPanel(id: UUID, solarPanel: SolarPanel) -> Bool
}
