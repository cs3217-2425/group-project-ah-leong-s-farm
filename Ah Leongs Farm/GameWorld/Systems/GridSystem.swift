import GameplayKit

class GridSystem: ISystem {
    unowned var manager: EntityManager?

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    private var grid: GridComponent? {
        manager?.getSingletonComponent(ofType: GridComponent.self)
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

        let crop = CropComponent(cropType: cropType)

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
