//
//  YieldComponent.swift
//  Ah Leongs Farm
//
//  Created by proglab on 25/3/25.
//

import Foundation

class YieldComponent: ComponentAdapter {
    var yield: Int
    var maxYield: Int

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    init(yield: Int, maxYield: Int) {
        self.yield = yield
        self.maxYield = maxYield
        super.init()
    }

    convenience init(maxYield: Int) {
        self.init(yield: maxYield, maxYield: maxYield)
    }
}
