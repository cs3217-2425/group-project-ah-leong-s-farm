//
//  MockGKEntity.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 22/3/25.
//

import GameplayKit

class MockGKEntity: GKEntity {
    override init() {
        super.init()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("Not implemented")
    }
}
