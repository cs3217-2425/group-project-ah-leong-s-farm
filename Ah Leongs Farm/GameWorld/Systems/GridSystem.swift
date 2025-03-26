import GameplayKit

class GridSystem: ISystem {
    unowned var manager: EntityManager?

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    private var grid: GridComponent? {
        manager?.getSingletonComponent(ofType: GridComponent.self)
    }

    /// Adds a crop entity to the `CropSlotComponent` of the entity at the specified row and column.
    /// - Returns: True if the crop is successfully added, false otherwise.
    /// Crop is only planted if the following conditions are fulfilled:
    /// - The entity at the specified row and column must have a `CropSlotComponent`.
    /// - The CropSlotComponent must not have any crops on it.
    /// - The entity to add `crop`, must have a `SeedComponent` and a `CropComponent`.
    @discardableResult
    func plantCrop(crop: GKEntity, row: Int, column: Int) -> Bool {
        guard let cropComponent = crop.component(ofType: CropComponent.self),
              crop.component(ofType: SeedComponent.self) != nil else {
            return false
        }

        guard let plotEntity = grid?.getEntity(row: row, column: column) else {
            return false
        }

        // Must have a crop slot
        guard let cropSlot = plotEntity.component(ofType: CropSlotComponent.self) else {
            return false
        }

        // Disallow planting on entity with an existing crop
        guard cropSlot.crop == nil else {
            return false
        }

        crop.removeComponent(ofType: SeedComponent.self)
        crop.addComponent(GrowthComponent(totalGrowthTurns: CropSystem.getTotalGrowthTurns(for: cropComponent.cropType)))
        cropSlot.crop = crop
        return true
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
