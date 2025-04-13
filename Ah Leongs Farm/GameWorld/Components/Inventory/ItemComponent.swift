//
//  ItemComponent.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 17/3/25.
//

import Foundation

class ItemComponent: ComponentAdapter {

    override init() {
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}
