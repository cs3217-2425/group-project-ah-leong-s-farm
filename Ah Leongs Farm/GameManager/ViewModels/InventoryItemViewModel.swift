//
//  InventoryItemViewModel.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 30/3/25.
//

import Foundation

struct InventoryItemViewModel {
    let name: String
    let imageName: String
    let quantity: Int
}

protocol InventoryDataProvider: AnyObject {
    func getInventoryItemViewModels() -> [InventoryItemViewModel]
    func getFertiliserItemViewModels() -> [PlotDisplayItemViewModel]
    func getSeedItemViewModels() -> [PlotDisplayItemViewModel]
    func getSolarPanelItemViewModels() -> [PlotDisplayItemViewModel]
}
