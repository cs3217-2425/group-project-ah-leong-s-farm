//
//  FarmLandQuery.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 13/4/25.
//

import Foundation

protocol FarmLandQuery {
    func fetch() -> [FarmLand]

    func fetchById(id: UUID) -> FarmLand?
}
