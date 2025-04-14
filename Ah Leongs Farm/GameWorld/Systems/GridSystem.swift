import Foundation

class GridSystem: ISystem {
    unowned var manager: EntityManager?

    private var gridComponent: GridComponent? {
        manager?.getSingletonComponent(ofType: GridComponent.self)
    }

    required init(for manager: EntityManager) {
        self.manager = manager
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
        guard let gridComponent = gridComponent else {
            return
        }

        let numRows = gridComponent.numberOfRows
        let numCols = gridComponent.numberOfColumns

        for r in 0..<numRows {
            for c in 0..<numCols {
                guard let plot = getPlot(row: r, column: c) else {
                    continue
                }

                guard let soilComponent = plot.getComponentByType(ofType: SoilComponent.self) else {
                    continue
                }

                soilComponent.hasWater = false
            }
        }
    }

    /// Adds a plot to the grid at the specified row and column.
    /// - Parameters:
    ///  - row: The row to add the plot to.
    ///  - column: The column to add the plot to.
    ///  - Returns: True if the plot was added, false otherwise.
    func addPlot(row: Int, column: Int) -> Bool {
        guard let gridComponent = gridComponent else {
            return false
        }

        guard gridComponent.getEntity(row: row, column: column) == nil else {
            return false
        }

        let plot = Plot(position: CGPoint(x: row, y: column))

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
        if let cropSlotComponent = plot.getComponentByType(ofType: CropSlotComponent.self),
           let crop = cropSlotComponent.crop {
            manager?.removeEntity(crop)
        }

        return true
    }
}
