import GameplayKit

class GridSystem: ISystem {
    unowned var manager: EntityManager?

    private var gridComponent: GridComponent? {
        manager?.getSingletonComponent(ofType: GridComponent.self)
    }

    required init(for manager: EntityManager) {
        self.manager = manager
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
}
