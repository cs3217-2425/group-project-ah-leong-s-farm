//
//  YieldComponent.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 25/3/25.
//

import Foundation

class YieldComponent: ComponentAdapter {
    var yield: Int
    var maxYield: Int

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    init(maxYield: Int) {
        self.yield = maxYield
        self.maxYield = maxYield
        super.init()
    }
}
