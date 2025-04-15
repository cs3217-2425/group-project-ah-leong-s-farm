//
//  PlotQuery.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 13/4/25.
//

import Foundation

protocol PlotQuery {
    func fetch(sessionId: UUID) -> [Plot]

    func fetchById(id: UUID) -> Plot?
}
