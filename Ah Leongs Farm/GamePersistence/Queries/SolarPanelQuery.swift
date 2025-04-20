//
//  SolarPanelQuery.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 19/4/25.
//

import Foundation

protocol SolarPanelQuery {
    func fetch(sessionId: UUID) -> [SolarPanel]
}
