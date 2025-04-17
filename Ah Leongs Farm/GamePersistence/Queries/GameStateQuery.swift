//
//  GameStateQuery.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 14/4/25.
//

import Foundation

protocol GameStateQuery {
    func fetch(sessionId: UUID) -> GameState?
}
