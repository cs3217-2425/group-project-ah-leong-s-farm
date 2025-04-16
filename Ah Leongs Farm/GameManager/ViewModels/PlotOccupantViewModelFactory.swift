//
//  PlotOccupantViewModelFactory.swift
//  Ah Leongs Farm
//
//  Created by proglab on 17/4/25.
//


class PlotOccupantViewModelFactory {
    static func makeViewModel(from occupant: PlotOccupant) -> PlotOccupantViewModel? {
        if let crop = occupant as? Crop {
            return CropViewModel(crop: crop)
        } else if let solarPanel = occupant as? SolarPanel {
            return SolarPanelViewModel(solarPanel: solarPanel)
        }
        return nil
    }
}

protocol PlotOccupantViewModel {
}
