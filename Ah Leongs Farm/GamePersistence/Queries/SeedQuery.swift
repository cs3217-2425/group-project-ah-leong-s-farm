//
//  SeedQuery.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 19/4/25.
//

import Foundation

protocol SeedQuery {
    func fetch(sessionId: UUID) -> [Seed]
}
