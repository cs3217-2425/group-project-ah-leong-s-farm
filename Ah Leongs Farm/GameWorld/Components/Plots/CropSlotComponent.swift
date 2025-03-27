//
//  CropSlotComponent.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 25/3/25.
//

import Foundation
import GameplayKit

class CropSlotComponent: GKComponent {
    var crop: Crop?

    init(crop: Crop? = nil) {
        guard let crop = crop, crop.component(ofType: CropComponent.self) != nil else {
            self.crop = nil
            super.init()
            return
        }

        self.crop = crop
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}
