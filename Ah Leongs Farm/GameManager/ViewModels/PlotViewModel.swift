//
//  PlotViewModel.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 5/4/25.
//

struct PlotViewModel {
    let row: Int
    let column: Int
    let occupant: PlotOccupantViewModel?

    var hasOccupant: Bool {
        occupant != nil
    }
}

protocol PlotDataProvider: AnyObject {
    func getPlotViewModel(row: Int, column: Int) -> PlotViewModel?

    func plantCrop(row: Int, column: Int, seedType: EntityType)

    func harvestCrop(row: Int, column: Int)

    func removeCrop(row: Int, column: Int)

    func waterPlot(row: Int, column: Int)

    func placeSolarPanel(row: Int, column: Int)

    func removeSolarPanel(row: Int, column: Int)

}
