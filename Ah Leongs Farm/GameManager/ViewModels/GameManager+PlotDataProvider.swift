//
//  GameManager+PlotDataProvider.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 5/4/25.
//

extension GameManager: PlotDataProvider {
    func getPlotViewModel(row: Int, column: Int) -> PlotViewModel? {
        guard let gridSystem = gameWorld.getSystem(ofType: GridSystem.self),
              let plot = gridSystem.getPlot(row: row, column: column)
        else {
            return nil
        }

        // Get the occupant from a unified slot component (PlotOccupantComponent)
        guard let occupant = plot.getComponentByType(ofType: PlotOccupantSlotComponent.self)?.plotOccupant else {
            return PlotViewModel(row: row, column: column, occupant: nil)
        }

        // Determine the type of occupant and construct the corresponding view model.
        let occupantViewModel: PlotOccupantViewModel?
        if let crop = occupant as? Crop, let cropVM = CropViewModel(crop: crop) {
            occupantViewModel = .crop(cropVM)
        } else if let solarPanel = occupant as? SolarPanel, let solarVM = SolarPanelViewModel(solarPanel: solarPanel) {
            occupantViewModel = .solarPanel(solarVM)
        } else {
            // If the occupant isn't recognized, you might choose to return nil or have a default case.
            occupantViewModel = nil
        }

        return PlotViewModel(row: row, column: column, occupant: occupantViewModel)
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

    func placeSolarPanel(row: Int, column: Int) {
        let event = PlaceSolarPanelEvent(row: row, column: column)
        gameWorld.queueEvent(event)
    }

    func removeSolarPanel(row: Int, column: Int) {
        let event = RemoveSolarPanelEvent(row: row, column: column)
        gameWorld.queueEvent(event)
    }
}
