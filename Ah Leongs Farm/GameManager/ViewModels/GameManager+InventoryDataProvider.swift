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

        let items = inventorySystem.getAllComponents()
            .compactMap { $0.ownerEntity }

        // Use the displayName as an identifier for the viewModel
        var viewModels: [String: InventoryItemViewModel] = [:]

        for item in items {
            let currDisplayName = displayService.getDisplayName(for: item)
            let currImageName = displayService.getImageName(for: item)

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
        guard let inventorySystem = gameWorld.getSystem(ofType: InventorySystem.self) else {
            return []
        }

        let items = inventorySystem.getAllComponents()
            .compactMap { $0.ownerEntity }

        let seedItems = items.filter {
            $0.getComponentByType(ofType: SeedComponent.self) != nil
        }

        // Use the displayName as an identifier for the viewModel
        var viewModels: [String: SeedItemViewModel] = [:]

        for item in seedItems {
            guard let cropComponent = item.getComponentByType(ofType: CropComponent.self) else {
                continue
            }
            let currDisplayName = displayService.getDisplayName(for: item)
            let currImageName = displayService.getImageName(for: item)

            if let existingViewModel = viewModels[currDisplayName] {
                viewModels[currDisplayName] = SeedItemViewModel(
                    cropType: cropComponent.cropType,
                    name: currDisplayName,
                    imageName: currImageName,
                    quantity: existingViewModel.quantity + 1
                )
            } else {
                viewModels[currDisplayName] = SeedItemViewModel(
                    cropType: cropComponent.cropType,
                    name: currDisplayName,
                    imageName: currImageName,
                    quantity: 1
                )
            }
        }
        return viewModels.values.sorted { $0.name < $1.name }
    }
}
