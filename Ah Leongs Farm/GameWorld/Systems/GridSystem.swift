import GameplayKit

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
}
