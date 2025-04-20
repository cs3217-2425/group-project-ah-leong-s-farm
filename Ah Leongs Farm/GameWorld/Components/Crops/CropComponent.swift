//
//  CropComponent.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 16/3/25.
//

import Foundation

class CropComponent: ComponentAdapter {
    override init() {
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}
