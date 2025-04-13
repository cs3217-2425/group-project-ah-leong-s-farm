//
//  CropComponent.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 16/3/25.
//

import Foundation

enum CropType: String, Hashable {
    case potato
    case apple
    case bokChoy
}

class CropComponent: ComponentAdapter {
    var cropType: CropType

    init(cropType: CropType) {
        self.cropType = cropType
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}
