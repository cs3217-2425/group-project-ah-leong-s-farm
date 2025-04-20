//
//  RenderComponent.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 18/4/25.
//

import Foundation
class RenderComponent: ComponentAdapter {
    let updatable: Bool

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(updatable: Bool) {
        self.updatable = updatable
        super.init()
    }
}
