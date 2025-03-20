import GameplayKit

class CropSystem: GKComponentSystem<CropComponent> {

    override init() {
        super.init(componentClass: GridComponent.self)
    }

    /// Create a new entity for a crop
    func plantCrop(ofType cropType: CropType, grid: GridComponent, row: Int, column: Int) -> CropComponent? {
        guard let entity = grid.getObject(row: row, column: column) else {
            return nil
        }

        // Disallow planting on entity with an existing crop
        if entity.component(ofType: CropComponent.self) != nil {
            return nil
        }

        let crop = CropComponent(
            cropType: cropType,
            health: 1,
            growth: 1,
            yieldPotential: 1,
            plantedTurn: 1
        )

        // Add crop component to entity
        entity.addComponent(crop)

        // Add crop component to system
        addComponent(crop)

        return crop
    }

    /// Remove crop entity and add harvested crop entity
    func harvestCrop(grid: GridComponent, row: Int, column: Int) -> CropComponent? {
        guard let entity = grid.getObject(row: row, column: column),
              let crop = entity.component(ofType: CropComponent.self) else {
            return nil
        }

        // Remove crop component from entity
        entity.removeComponent(ofType: CropComponent.self)

        // Remove crop component from system
        removeComponent(crop)

        return crop
    }
}
