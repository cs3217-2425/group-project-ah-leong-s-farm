import GameplayKit

class CropSystem: ISystem {
    unowned var manager: EntityManager?

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    static let cropsToGrowthMap: [CropType: Int] = [
        .bokChoy: 5,
        .apple: 10,
        .potato: 6
    ]

    static func getTotalGrowthTurns(for type: CropType) -> Int {
        cropsToGrowthMap[type] ?? 0
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
        crop.addComponent(GrowthComponent(totalGrowthTurns:
                                            CropSystem.getTotalGrowthTurns(for: cropComponent.cropType)))
        cropSlot.crop = crop
        return true
    }

    /// Harvests the crop at the specified row and column.
    /// - Returns: True if the crop is successfully harvested, false otherwise.
    func harvestCrop(row: Int, column: Int) -> Bool {
        guard let plotEntity = grid?.getEntity(row: row, column: column) else {
            return false
        }

        guard let cropSlot = plotEntity.component(ofType: CropSlotComponent.self),
              let crop = cropSlot.crop else {
            return false
        }

        guard let growthComponent = crop.component(ofType: GrowthComponent.self) else {
            return false
        }

        guard growthComponent.canHarvest else {
            return false
        }

        crop.removeComponent(ofType: GrowthComponent.self)
        crop.addComponent(HarvestedComponent())
        cropSlot.crop = nil
        // TODO: Send event to store in Inventory

        return true
    }
}
