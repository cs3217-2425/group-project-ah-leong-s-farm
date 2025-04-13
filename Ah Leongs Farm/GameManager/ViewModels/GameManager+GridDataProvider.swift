//
//  GameManager+GridDataProvider.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 4/4/25.
//

extension GameManager: GridDataProvider {
    func getGridViewModel(row: Int, column: Int) -> GridViewModel {
        guard let gridSystem = gameWorld.getSystem(ofType: GridSystem.self) else {
            return GridViewModel(row: row, column: column, doesPlotExist: false)
        }

        let doesPlotExist = gridSystem.getPlot(row: row, column: column) != nil

        return GridViewModel(row: row, column: column, doesPlotExist: doesPlotExist)
    }

    func addPlot(row: Int, column: Int) {
        let event = AddPlotEvent(row: row, column: column)
        gameWorld.queueEvent(event)
    }

    func razePlot(row: Int, column: Int) {
        let event = RazePlotEvent(row: row, column: column)
        gameWorld.queueEvent(event)
    }
}
