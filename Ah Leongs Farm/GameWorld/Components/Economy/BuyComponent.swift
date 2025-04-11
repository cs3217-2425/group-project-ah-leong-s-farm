//
//  BuyComponent.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 11/4/25.
//

import Foundation
class BuyComponent: ComponentAdapter {
    
    var price: [CurrencyType: Int]

    init(price: [CurrencyType: Int]) {
        self.price = price
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
