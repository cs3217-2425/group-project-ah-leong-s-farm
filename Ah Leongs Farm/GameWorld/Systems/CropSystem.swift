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
    func harvestCrop(row: Int, column: Int) -> (type: EntityType, crops: [Crop])? {
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

        let yield = crop.getComponentByType(ofType: YieldComponent.self)?.yield ?? 0

        let concreteType = type(of: crop).type

        plotOccupantSlot.plotOccupant = nil

        let crops = CropFactory.createMultiple(type: crop.type, quantity: yield).compactMap { $0 as? Crop }
        for crop in crops {
            manager?.addComponent(HarvestedComponent(), to: crop)
            manager?.addEntity(crop)
        }

        manager?.removeEntity(crop)

        return (type: concreteType, crops: crops)
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

    func updateCropStates() {
        guard let grid = grid else {
            return
        }

        for r in 0..<grid.numberOfRows {
            for c in 0..<grid.numberOfColumns {
                guard let plot = grid.getEntity(row: r, column: c),
                      let plotOccupantSlot = plot.getComponentByType(ofType: PlotOccupantSlotComponent.self),
                      let crop = plotOccupantSlot.plotOccupant as? Crop else {
                    continue
                }

                growCrop(for: crop, plot: plot)
                updateHealth(for: crop, plot: plot)
                updateYield(for: crop)
            }
        }
    }

    func growCrop(for crop: Crop, plot: Entity) {
        guard let growthComponent = crop.getComponentByType(ofType: GrowthComponent.self),
              let soil = plot.getComponentByType(ofType: SoilComponent.self),
              soil.hasWater else {
            return
        }

        growthComponent.currentGrowthTurn += soil.quality
    }

    func updateHealth(for crop: Crop, plot: Entity) {
        guard let manager = manager,
              let soilComponent = plot.getComponentByType(ofType: SoilComponent.self),
              let healthComponent = crop.getComponentByType(ofType: HealthComponent.self),
              let plotOccupantSlot = plot.getComponentByType(ofType: PlotOccupantSlotComponent.self) else {
            return
        }

        var healthChange: Double = -0.05
        if !soilComponent.hasWater {
            healthChange *= 4.0 // UNWATERED_DECAY_MULTIPLIER
        }
        if soilComponent.quality > 5.0 {
            healthChange += 0.2 // SOIL_QUALITY_BONUS
        }

        let maxHealth = healthComponent.maxHealth
        let newHealth = healthComponent.health + healthChange
        let roundedHealth = (newHealth * 100).rounded() / 100
        healthComponent.health = max(0, min(roundedHealth, maxHealth))

        if healthComponent.health <= 0 {
            manager.removeEntity(crop)
            plotOccupantSlot.plotOccupant = nil
        }
    }

    func updateYield(for crop: Crop) {
        guard let yieldComponent = crop.getComponentByType(ofType: YieldComponent.self),
              let healthComponent = crop.getComponentByType(ofType: HealthComponent.self) else {
            return
        }

        let healthRatio = max(0.0, min(1.0, healthComponent.health / healthComponent.maxHealth))
        yieldComponent.yield = Int(Double(yieldComponent.maxYield) * healthRatio)
    }

}
