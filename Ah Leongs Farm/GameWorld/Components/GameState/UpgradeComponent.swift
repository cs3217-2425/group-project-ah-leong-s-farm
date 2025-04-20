//
//  UpgradeComponent.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 16/4/25.
//

import Foundation
class UpgradeComponent: ComponentAdapter {
    var points: Int

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    init(points: Int = 0) {
        self.points = points
        super.init()
    }
}
