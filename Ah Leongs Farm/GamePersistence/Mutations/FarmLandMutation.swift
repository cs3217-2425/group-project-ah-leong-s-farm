//
//  FarmLandMutation.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 13/4/25.
//

import Foundation

protocol FarmLandMutation {
    func upsertFarmLand(id: UUID, farmLand: FarmLand) -> Bool

    func deleteFarmLand(id: UUID) -> Bool
}
