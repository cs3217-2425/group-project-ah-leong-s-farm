//
//  InventoryComponent.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 20/3/25.
//

import Foundation
import GameplayKit

class InventoryComponent: GKComponent {
    var items: Set<GKEntity>

    init(items: Set<GKEntity> = Set()) {
        self.items = items
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}
