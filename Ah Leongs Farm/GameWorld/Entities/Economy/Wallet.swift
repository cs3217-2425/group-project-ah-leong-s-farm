//
//  Wallet.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 19/3/25.
//

import Foundation
import GameplayKit

class Wallet: GKEntity {
    override init() {
        super.init()
        setUpComponents()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    private func setUpComponents() {
        let walletComponent = WalletComponent()
        addComponent(walletComponent)
    }
}
