//
//  PlotViewModel.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 5/4/25.
//

struct PlotViewModel {
    let row: Int
    let column: Int
    let crop: CropViewModel?

    var hasCrop: Bool {
        crop != nil
    }
}

protocol PlotDataProvider: AnyObject {
    func getPlotViewModel(row: Int, column: Int) -> PlotViewModel?

    func plantCrop(row: Int, column: Int, cropType: CropType)

    func harvestCrop(row: Int, column: Int)

    func removeCrop(row: Int, column: Int)
}
