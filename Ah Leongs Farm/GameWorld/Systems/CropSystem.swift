import Foundation

class CropSystem: ISystem {
    unowned var manager: EntityManager?

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    static let cropsToGrowthTurnsMap: [EntityType: Int] = [
        BokChoy.type: 5,
        Apple.type: 10,
        Potato.type: 6
    ]

    static let cropsToGrowthStagesMap: [EntityType: Int] = [
        BokChoy.type: 2,
        Apple.type: 3,
        Potato.type: 1
    ]

    static func getTotalGrowthTurns(for type: EntityType) -> Int {
        cropsToGrowthTurnsMap[type] ?? 0
    }

    static func getTotalGrowthStages(for type: EntityType) -> Int {
        cropsToGrowthStagesMap[type] ?? 0
    }

    private var grid: GridComponent? {
        manager?.getSingletonComponent(ofType: GridComponent.self)
    }

    private var growingCrops: [GrowthComponent] {
        manager?.getAllComponents(ofType: GrowthComponent.self) ?? []
    }

    func isOccupied(row: Int, column: Int) -> Bool {
        guard let plotEntity = grid?.getEntity(row: row, column: column) else {
            return false
        }

        // Must have a crop slot
        guard let plotOccupantSlot = plotEntity.getComponentByType(ofType: PlotOccupantSlotComponent.self) else {
            return false
        }

        // Disallow planting on entity with an existing crop
        return plotOccupantSlot.plotOccupant != nil
    }

    /// Adds a crop entity to the `CropSlotComponent` of the entity at the specified row and column.
    /// - Returns: True if the crop is successfully added, false otherwise.
    /// Crop is only planted if the following conditions are fulfilled:
    /// - The entity at the specified row and column must have a `CropSlotComponent`.
    /// - The CropSlotComponent must not have any crops on it.
    /// - The entity to add `crop`, must have a `SeedComponent` and a `CropComponent`.
    @discardableResult
    func plantCrop(crop: Crop, row: Int, column: Int) -> Bool {
        guard let plotEntity = grid?.getEntity(row: row, column: column) else {
            return false
        }

        guard let plotOccupantSlot = plotEntity.getComponentByType(ofType: PlotOccupantSlotComponent.self) else {
            return false
        }

        guard crop.component(ofType: CropComponent.self) != nil else {
            return false
        }
        manager?.addComponent(GrowthComponent(
            totalGrowthTurns: CropSystem.getTotalGrowthTurns(for: crop.type),
            totalGrowthStages: CropSystem.getTotalGrowthStages(for: crop.type)), to: crop)
        manager?.addComponent(PositionComponent(x: CGFloat(row), y: CGFloat(column)), to: crop)
        manager?.addComponent(SpriteComponent(visitor: crop,
                                              updateVisitor: crop), to: crop)
        manager?.addComponent(RenderComponent(updatable: true), to: crop)
        plotOccupantSlot.plotOccupant = crop
        return true
    }

    /// Harvests the crop at the specified row and column.
    /// - Returns: Harvested crop if any, `nil` otherwise.
    @discardableResult
    func harvestCrop(row: Int, column: Int) -> Crop? {
        guard let plotEntity = grid?.getEntity(row: row, column: column) else {
            return nil
        }

        guard let plotOccupantSlot = plotEntity.getComponentByType(ofType: PlotOccupantSlotComponent.self),
              let crop = plotOccupantSlot.plotOccupant as? Crop else {
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
        manager?.removeComponent(ofType: RenderComponent.self, from: crop)
        manager?.addComponent(HarvestedComponent(), to: crop)
        plotOccupantSlot.plotOccupant = nil
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

        guard let plotOccupantSlot = plotEntity.getComponentByType(ofType: PlotOccupantSlotComponent.self),
              let crop = plotOccupantSlot.plotOccupant as? Crop else {
            return false
        }

        manager.removeEntity(crop)
        plotOccupantSlot.plotOccupant = nil

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

                guard let plotOccupantSlot = plot.getComponentByType(ofType: PlotOccupantSlotComponent.self),
                      let crop = plotOccupantSlot.plotOccupant as? Crop else {
                    continue
                }

                guard let growthComponent = crop.getComponentByType(ofType: GrowthComponent.self) else {
                    continue
                }

                guard let soil = plot.getComponentByType(ofType: SoilComponent.self) else {
                    continue
                }

                if soil.hasWater {
                    growthComponent.currentGrowthTurn += soil.quality
                }
            }
        }
    }
}
