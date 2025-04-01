//
//  GameManager+InventoryDataProvider.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 30/3/25.
//

import Foundation

extension GameManager: InventoryDataProvider {
    func getInventoryItemViewModels() -> [InventoryItemViewModel] {
        guard let inventorySystem = gameWorld.getSystem(ofType: InventorySystem.self) else {
            return []
        }

        let itemsByQuantity = inventorySystem.getItemsByQuantity()
        var viewModels: [InventoryItemViewModel] = []

        for (itemType, quantity) in itemsByQuantity {
            guard let name = ItemToViewDataMap.itemTypeToDisplayName[itemType],
                  let imageName = ItemToViewDataMap.itemTypeToImage[itemType] else {
                fatalError("Name or image not stored in ItemToViewDataMap for \(itemType)")
            }
            viewModels.append(InventoryItemViewModel(
                name: name,
                imageName: imageName,
                quantity: quantity
            ))
        }
        return viewModels.sorted { $0.name < $1.name }
    }
}


