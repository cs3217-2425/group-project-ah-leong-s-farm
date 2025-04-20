//
//  SolarPanelPersistenceEntity+Deserializer.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 19/4/25.
//

import Foundation

extension SolarPanelPersistenceEntity {
    func deserialize() -> SolarPanel {
        var position: CGPoint?

        if let positionComponent = positionComponent {
            position = CGPoint(x: CGFloat(positionComponent.x), y: CGFloat(positionComponent.y))
        }

        guard let persistenceId = id else {
            let newPersistenceId = UUID()
            id = newPersistenceId

            let config = SolarPanelConfig(
                persistenceId: newPersistenceId,
                isItem: isItem,
                position: position
            )

            return SolarPanel(config: config)
        }

        let config = SolarPanelConfig(
            persistenceId: persistenceId,
            isItem: isItem,
            position: position
        )

        return SolarPanel(config: config)
    }
}
