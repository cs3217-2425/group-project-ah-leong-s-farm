import GameplayKit

class CropSystem: GKComponentSystem<CropComponent> {

    override init() {
        super.init(componentClass: GridComponent.self)
    }

    /// Create a new entity for a crop
    func plantCrop(ofType cropType: CropType, at plot: Plot) -> CropComponent? {
        if let crop = plot.component(ofType: CropComponent.self) {
            return nil
        }
    
        guard let position = plot.component(ofType: PositionComponent.self),
              let soil = plot.component(ofType: SoilComponent.self) else {
            return nil
        }

        let crop = CropComponent(
            cropType: cropType,
            health: 1,
            growth: 1,
            yieldPotential: 1,
            plantedTurn: 1
        )

        plot.addComponent(crop)
        return crop
    }

    /// Remove crop entity and add harvested crop entityx
    func harvestCrop(at plot: Plot) -> CropComponent? {
        guard let crop = plot.component(ofType: CropComponent.self) else {
            return nil
        }

        plot.removeComponent(ofType: CropComponent.self)

        return crop
    }

}

