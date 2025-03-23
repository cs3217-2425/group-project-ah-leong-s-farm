import GameplayKit

class GridSystem: GKComponentSystem<GridComponent> {

    var grid: GridComponent? {
        components.first
    }

    override init() {
        super.init(componentClass: GridComponent.self)
    }

    /// Add a grid component to the system. Only up to one grid component is to be managed at all times.
    override func addComponent(_ component: GridComponent) {
        guard components.isEmpty else {
            return
        }

        super.addComponent(component)
    }

    /// Adds crop component to the entity at the specified row and column
    /// Crop component is not added if the entity already has one.
    /// **This method does not add crop to `CropSystem`.**
    func plantCrop(cropType: CropType, row: Int, column: Int) -> CropComponent? {
        guard let entity = grid?.getEntity(row: row, column: column) else {
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

        return crop
    }

    /// Harvests the crop at the specified row and column.
    /// **This method does not remove crop from `CropSystem`.**
    func harvestCrop(row: Int, column: Int) -> CropComponent? {
        guard let entity = grid?.getEntity(row: row, column: column),
              let crop = entity.component(ofType: CropComponent.self) else {
            return nil
        }

        entity.removeComponent(ofType: CropComponent.self)

        return crop
    }
}
