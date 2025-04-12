import Foundation

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

    private var growingCrops: [GrowthComponent] {
        manager?.getAllComponents(ofType: GrowthComponent.self) ?? []
    }

    /// Adds a crop entity to the `CropSlotComponent` of the entity at the specified row and column.
    /// - Returns: True if the crop is successfully added, false otherwise.
    /// Crop is only planted if the following conditions are fulfilled:
    /// - The entity at the specified row and column must have a `CropSlotComponent`.
    /// - The CropSlotComponent must not have any crops on it.
    /// - The entity to add `crop`, must have a `SeedComponent` and a `CropComponent`.
    @discardableResult
    func plantCrop(crop: Crop, row: Int, column: Int) -> Bool {
        guard let cropComponent = crop.getComponentByType(ofType: CropComponent.self),
              crop.getComponentByType(ofType: SeedComponent.self) != nil else {
            return false
        }

        guard let plotEntity = grid?.getEntity(row: row, column: column) else {
            return false
        }

        // Must have a crop slot
        guard let cropSlot = plotEntity.getComponentByType(ofType: CropSlotComponent.self) else {
            return false
        }

        // Disallow planting on entity with an existing crop
        guard cropSlot.crop == nil else {
            return false
        }

        manager?.removeComponent(ofType: SeedComponent.self, from: crop)
        manager?.removeComponent(ofType: ItemComponent.self, from: crop)
        manager?.removeComponent(ofType: SellComponent.self, from: crop)
        manager?.addComponent(GrowthComponent(
            totalGrowthTurns: CropSystem.getTotalGrowthTurns(for: cropComponent.cropType)), to: crop)
        manager?.addComponent(PositionComponent(x: CGFloat(row), y: CGFloat(column)), to: crop)
        cropSlot.crop = crop
        return true
    }

    /// Harvests the crop at the specified row and column.
    /// - Returns: Harvested crop if any, `nil` otherwise.
    @discardableResult
    func harvestCrop(row: Int, column: Int) -> Crop? {
        guard let plotEntity = grid?.getEntity(row: row, column: column) else {
            return nil
        }

        guard let cropSlot = plotEntity.getComponentByType(ofType: CropSlotComponent.self),
              let crop = cropSlot.crop else {
            return nil
        }

        guard let growthComponent = crop.getComponentByType(ofType: GrowthComponent.self) else {
            return nil
        }

        guard growthComponent.canHarvest else {
            return nil
        }

        manager?.removeComponent(ofType: GrowthComponent.self, from: crop)
        manager?.removeComponent(ofType: PositionComponent.self, from: crop)
        manager?.addComponent(HarvestedComponent(), to: crop)
        manager?.addComponent(SellComponent(), to: crop)
        manager?.addComponent(ItemComponent(), to: crop)
        cropSlot.crop = nil
        return crop
    }

    /// Removes the crop from the specified row and column.
    /// - Returns: `true` if crop is removed, `false` otherwise.
    func removeCrop(row: Int, column: Int) -> Bool {
        guard let manager = manager else {
            return false
        }

        guard let plotEntity = grid?.getEntity(row: row, column: column) else {
            return false
        }

        guard let cropSlot = plotEntity.getComponentByType(ofType: CropSlotComponent.self),
              let crop = cropSlot.crop else {
            return false
        }

        manager.removeEntity(crop)
        cropSlot.crop = nil

        return true
    }

    func growCrops() {
        for crop in growingCrops {
            crop.currentGrowthTurn += 1
        }
    }

    /// Retrieves all seed entities of the specified crop type.
    ///
    /// - Parameter type: The type of crop to filter seed entities by.
    /// - Returns: An array of `Crop` entities that match the specified crop type.
    func getAllSeedEntities(for type: CropType) -> [Crop] {
        guard let manager = manager else {
            return []
        }

        let seedEntities = manager.getEntities(withComponentTypes: [SeedComponent.self, CropComponent.self])

        let filteredCrops = seedEntities.compactMap { entity -> Crop? in
            guard let cropComponent = entity.getComponentByType(ofType: CropComponent.self),
                  cropComponent.cropType == type,
                  let crop = entity as? Crop
            else {
                return nil
            }

            return crop
        }

        return filteredCrops
    }

}
