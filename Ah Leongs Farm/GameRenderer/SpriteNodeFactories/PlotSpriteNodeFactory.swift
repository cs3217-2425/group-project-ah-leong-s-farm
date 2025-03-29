//
//  PlotSpriteNodeFactory.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 30/3/25.
//

import SpriteKit

class PlotSpriteNodeFactory: SpriteNodeFactory {
    func createNode(for entity: EntityType, textureName: String) -> PlotSpriteNode? {
        guard entity.component(ofType: SoilComponent.self) != nil,
              entity.component(ofType: CropSlotComponent.self) != nil else {
            return nil
        }

        return PlotSpriteNode(imageNamed: textureName)
    }
}
