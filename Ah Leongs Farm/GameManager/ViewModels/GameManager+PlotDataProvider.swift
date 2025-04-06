//
//  GameManager+PlotDataProvider.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 5/4/25.
//

extension GameManager: PlotDataProvider {
    func getPlotViewModel(row: Int, column: Int) -> PlotViewModel? {
        guard let gridSystem = gameWorld.getSystem(ofType: GridSystem.self) else {
            return nil
        }

        guard let plot = gridSystem.getPlot(row: row, column: column) else {
            return nil
        }

        guard let crop = plot.component(ofType: CropSlotComponent.self)?.crop else {
            return PlotViewModel(row: row, column: column, crop: nil)
        }

        let cropViewModel = CropViewModel(crop: crop)

        return PlotViewModel(row: row, column: column, crop: cropViewModel)
    }

    func plantCrop(row: Int, column: Int, cropType: CropType) {
        let event = PlantCropEvent(row: row, column: column, cropType: cropType)
        gameWorld.queueEvent(event)
    }

    func harvestCrop(row: Int, column: Int) {
        let event = HarvestCropEvent(row: row, column: column)
        gameWorld.queueEvent(event)
    }

    func removeCrop(row: Int, column: Int) {
        let event = RemoveCropEvent(row: row, column: column)
        gameWorld.queueEvent(event)
    }
}
