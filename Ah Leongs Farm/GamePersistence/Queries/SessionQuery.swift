//
//  SessionQuery.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 15/4/25.
//

import Foundation

protocol SessionQuery {
    func fetch() -> [SessionData]

    func fetchById(sessionId: UUID) -> SessionData?
}

extension SessionQuery {
    func doesSessionExist(sessionId: UUID) -> Bool {
        fetchById(sessionId: sessionId) != nil
    }
}
