//
//  FarmLandPersistenceEntity+Deserializer.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 13/4/25.
//

extension FarmLandPersistenceEntity {
    func deserialize() -> FarmLand {
        FarmLand(rows: Int(gridRows), columns: Int(gridColumns))
    }
}

