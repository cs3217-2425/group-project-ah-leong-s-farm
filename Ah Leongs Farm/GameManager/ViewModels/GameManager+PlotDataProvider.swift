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

        guard let plot = gridSystem.getPlot(row: row, column: column),
              let soilComponent = plot.getComponentByType(ofType: SoilComponent.self) else {
            return nil
        }

        guard let crop = plot.getComponentByType(ofType: CropSlotComponent.self)?.crop else {
            return PlotViewModel(row: row,
                                 column: column,
                                 crop: nil,
                                 soilQuality: soilComponent.quality,
                                 maxSoilQuality: soilComponent.maxQuality)
        }

        let cropViewModel = CropViewModel(crop: crop)

        return PlotViewModel(row: row,
                             column: column,
                             crop: cropViewModel,
                             soilQuality: soilComponent.quality,
                             maxSoilQuality: soilComponent.maxQuality)
    }

    func plantCrop(row: Int, column: Int, seedType: EntityType) {
        let event = PlantCropEvent(row: row, column: column, seedType: seedType)
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

    func waterPlot(row: Int, column: Int) {
        let event = WaterPlotEvent(row: row, column: column)
        gameWorld.queueEvent(event)
    }

    func useFertiliser(row: Int, column: Int, fertiliserType: EntityType) {
         let event = UseFertiliserEvent(row: row, column: column, fertiliserType: fertiliserType)
         gameWorld.queueEvent(event)
     }
}
