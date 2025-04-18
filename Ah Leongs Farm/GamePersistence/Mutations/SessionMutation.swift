//
//  SessionMutation.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 15/4/25.
//

import Foundation

protocol SessionMutation {
    func upsertSession(session: SessionData) -> Bool

    func deleteSession(id: UUID) -> Bool
}
