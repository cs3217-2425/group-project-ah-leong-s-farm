//
//  AbstractSolarPanelPersistenceManager.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 19/4/25.
//

import Foundation

protocol AbstractSolarPanelPersistenceManager {
    var sessionId: UUID { get }
    var solarPanelQuery: (any SolarPanelQuery)? { get }
    var solarPanelMutation: (any SolarPanelMutation)? { get }
}

extension AbstractSolarPanelPersistenceManager {
    func loadSolarPanels() -> [SolarPanel] {
        guard let solarPanelQuery = solarPanelQuery else {
            return []
        }

        return solarPanelQuery.fetch(sessionId: sessionId)
    }

    func save(solarPanel: SolarPanel, persistenceId: UUID) -> Bool {
        guard let solarPanelMutation = solarPanelMutation else {
            return false
        }

        return solarPanelMutation
            .upsertSolarPanel(
                sessionId: sessionId,
                id: persistenceId,
                solarPanel: solarPanel
            )
    }

    func delete(solarPanel: SolarPanel, persistenceId: UUID) -> Bool {
        guard let solarPanelMutation = solarPanelMutation else {
            return false
        }

        return solarPanelMutation.deleteSolarPanel(id: persistenceId, solarPanel: solarPanel)
    }

}
