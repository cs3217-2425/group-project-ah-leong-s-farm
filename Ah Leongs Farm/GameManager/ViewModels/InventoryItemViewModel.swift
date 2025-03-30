//
//  InventoryItemViewModel.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 30/3/25.
//

import Foundation

// A UI-friendly model for displaying inventory items
struct InventoryItemViewModel {
    let name: String
    let imageName: String
    let quantity: Int
}

// Protocol for providing inventory data to the UI
protocol InventoryDataProvider {
    func getInventoryItemViewModels() -> [InventoryItemViewModel]
}
