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
    func plantCrop(seed: Seed, row: Int, column: Int) -> Bool {
        guard seed.getComponentByType(ofType: SeedComponent.self) != nil else {
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
        let crop = seed.toCrop()
        manager?.addEntity(crop)
        // TODO: Shouldn't need to access cropComponent.cropType after removing CropType
        guard let cropComponent = crop.component(ofType: CropComponent.self) else {
            return false
        }
        manager?.removeEntity(seed)

        manager?.addComponent(GrowthComponent(
            totalGrowthTurns: CropSystem.getTotalGrowthTurns(for: cropComponent.cropType)), to: crop)
        manager?.addComponent(PositionComponent(x: CGFloat(row), y: CGFloat(column)), to: crop)
        manager?.addComponent(SpriteComponent(visitor: crop), to: crop)
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
        manager?.removeComponent(ofType: SpriteComponent.self, from: crop)
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
        guard let grid = grid else {
            return
        }

        for r in 0..<grid.numberOfRows {
            for c in 0..<grid.numberOfColumns {
                guard let plot = grid.getEntity(row: r, column: c) else {
                    continue
                }

                guard let cropSlot = plot.getComponentByType(ofType: CropSlotComponent.self),
                      let crop = cropSlot.crop else {
                    continue
                }

                guard let growthComponent = crop.getComponentByType(ofType: GrowthComponent.self) else {
                    continue
                }

                guard let soil = plot.getComponentByType(ofType: SoilComponent.self) else {
                    continue
                }

                if soil.hasWater {
                    growthComponent.currentGrowthTurn += 1
                }
            }
        }
    }

    /// Retrieves all seed entities of the specified crop type.
    ///
    /// - Parameter type: The type of crop to filter seed entities by.
    /// - Returns: An array of `Crop` entities that match the specified crop type.
    func getAllSeedEntities(for type: EntityType) -> [Seed] {
        guard let manager = manager else {
            return []
        }

        let seedEntities = manager.getEntities(withComponentType: SeedComponent.self)
            .filter { $0.type == type }
            .compactMap({
                $0 as? Seed
            })

        return seedEntities
    }

}
