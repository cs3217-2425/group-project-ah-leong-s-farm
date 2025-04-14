//
//  GameManager+InventoryDataProvider.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 30/3/25.
//

import Foundation

extension GameManager: InventoryDataProvider {
    func getInventoryItemViewModels() -> [InventoryItemViewModel] {

        let items = gameWorld.getAllEntities()
            .filter {
                $0.getComponentByType(ofType: ItemComponent.self) != nil
            }

        // Use the displayName as an identifier for the viewModel
        var viewModels: [String: InventoryItemViewModel] = [:]

        for item in items {
            guard let currDisplayName = ItemToViewDataMap
                .itemTypeToDisplayName[item.type],
                  let currImageName = ItemToViewDataMap
                .itemTypeToImage[item.type] else {
                continue
            }

            if let existingViewModel = viewModels[currDisplayName] {
                viewModels[currDisplayName] = InventoryItemViewModel(
                    name: currDisplayName,
                    imageName: currImageName,
                    quantity: existingViewModel.quantity + 1
                )
            } else {
                viewModels[currDisplayName] = InventoryItemViewModel(
                    name: currDisplayName,
                    imageName: currImageName,
                    quantity: 1
                )
            }
        }
        return viewModels.values.sorted { $0.name < $1.name }
    }

    func getSeedItemViewModels() -> [SeedItemViewModel] {

        let seedItems = gameWorld.getAllEntities()
            .filter {
                $0.getComponentByType(ofType: SeedComponent.self) != nil
            }

        // Use the displayName as an identifier for the viewModel
        var viewModels: [String: SeedItemViewModel] = [:]

        for item in seedItems {
            guard let currDisplayName = ItemToViewDataMap
                .itemTypeToDisplayName[item.type],
                  let currImageName = ItemToViewDataMap
                .itemTypeToImage[item.type] else {
                continue
            }

            if let existingViewModel = viewModels[currDisplayName] {
                viewModels[currDisplayName] = SeedItemViewModel(
                    seedType: item.type,
                    name: currDisplayName,
                    imageName: currImageName,
                    quantity: existingViewModel.quantity + 1
                )
            } else {
                viewModels[currDisplayName] = SeedItemViewModel(
                    seedType: item.type,
                    name: currDisplayName,
                    imageName: currImageName,
                    quantity: 1
                )
            }
        }
        return viewModels.values.sorted { $0.name < $1.name }
    }
}
