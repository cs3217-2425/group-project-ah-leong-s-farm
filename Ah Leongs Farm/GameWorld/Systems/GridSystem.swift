import Foundation

class GridSystem: ISystem {
    unowned var manager: EntityManager?

    private var gridComponent: GridComponent? {
        manager?.getSingletonComponent(ofType: GridComponent.self)
    }

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    private var allPlots: [Plot] {
        var plots: [Plot] = []

        guard let gridComponent = gridComponent else {
            return plots
        }

        let numRows = gridComponent.numberOfRows
        let numCols = gridComponent.numberOfColumns

        for r in 0..<numRows {
            for c in 0..<numCols {
                guard let plot = getPlot(row: r, column: c) else {
                    continue
                }

                plots.append(plot)
            }
        }

        return plots
    }

    func getPlot(row: Int, column: Int) -> Plot? {
        guard let gridComponent = gridComponent else {
            return nil
        }

        return gridComponent.getEntity(row: row, column: column) as? Plot
    }

    func waterPlot(row: Int, column: Int) {
        guard let plot = self.getPlot(row: row, column: column) else {
            return
        }

        guard let soil = plot.getComponentByType(ofType: SoilComponent.self) else {
            return
        }

        soil.hasWater = true
    }

    func unwaterPlots() {
        for plot in allPlots {
            guard let soilComponent = plot.getComponentByType(ofType: SoilComponent.self) else {
                continue
            }

            soilComponent.hasWater = false
        }
    }

    private let UNWATERED_DECAY_MULTIPLER: Double = 4.0
    private let SOIL_QUALITY_BONUS: Double = 0.2

    func updateHealth() {
        guard let manager = manager else {
            return
        }

        for plot in allPlots {
            guard let soilComponent = plot.getComponentByType(ofType: SoilComponent.self) else {
                continue
            }

            guard let plotOccupantSlot = plot.getComponentByType(ofType: PlotOccupantSlotComponent.self),
                  let crop = plotOccupantSlot.plotOccupant as? Crop,
                  let healthComponent = crop.getComponentByType(ofType: HealthComponent.self) else {
                continue
            }

            var healthChange: Double = -0.05

            if !soilComponent.hasWater {
                healthChange *= UNWATERED_DECAY_MULTIPLER
            }

            if soilComponent.quality > 5.0 {
                healthChange += SOIL_QUALITY_BONUS
            }

            let maxHealth = healthComponent.maxHealth
            let newHealth = healthComponent.health + healthChange

            // 2 d.p. to prevent issues with floating point precision
            let roundedHealth = (newHealth * 100).rounded() / 100
            healthComponent.health = max(0, min(roundedHealth, maxHealth))

            // Remove dead crops
            if healthComponent.health <= 0 {
                manager.removeEntity(crop)
                plotOccupantSlot.plotOccupant = nil
            }
        }
    }

    /// Adds a plot to the grid at the specified row and column.
    /// - Parameters:
    ///  - row: The row to add the plot to.
    ///  - column: The column to add the plot to.
    ///  - Returns: True if the plot was added, false otherwise.
    func addPlot(_ plot: Plot) -> Bool {
        guard let gridComponent = gridComponent else {
            return false
        }

        guard let positionComponent =
            plot.getComponentByType(ofType: PositionComponent.self) else {
                return false
            }
        let row = Int(positionComponent.x)
        let column = Int(positionComponent.y)

        guard gridComponent.getEntity(row: row, column: column) == nil else {
            return false
        }

        gridComponent.setEntity(plot, row: row, column: column)
        manager?.addEntity(plot)

        return true
    }

    /// Removes plot and crop, if any, from the grid at the specified row and column.
    /// - Parameters:
    /// - row: The row to remove the plot from.
    /// - column: The column to remove the plot from.
    /// - Returns: True if the plot was removed, false otherwise.
    func razePlot(row: Int, column: Int) -> Bool {
        guard let gridComponent = gridComponent,
              let plot = gridComponent.getEntity(row: row, column: column) as? Plot
        else {
            return false
        }

        gridComponent.setEntity(nil, row: row, column: column)
        manager?.removeEntity(plot)

        // Remove the crop from the entity manager if it exists
        if let plotOccupantSlotComponent = plot.getComponentByType(ofType: PlotOccupantSlotComponent.self),
           let plotOccupant = plotOccupantSlotComponent.plotOccupant {
            manager?.removeEntity(plotOccupant)
        }

        return true
    }
}
