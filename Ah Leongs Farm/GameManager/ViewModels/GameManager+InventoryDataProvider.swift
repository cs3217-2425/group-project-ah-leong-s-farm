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

    func getSeedItemViewModels() -> [PlotDisplayItemViewModel] {

        let seedItems = gameWorld.getAllEntities()
            .filter {
                $0.getComponentByType(ofType: SeedComponent.self) != nil
            }
        return entitiesToPlotDisplayViewModel(seedItems)
    }

    func getFertiliserItemViewModels() -> [PlotDisplayItemViewModel] {
        let fertiliserItems = gameWorld.getAllEntities()
            .filter {
                $0 is Fertiliser
            }
        return entitiesToPlotDisplayViewModel(fertiliserItems)
    }

    private func entitiesToPlotDisplayViewModel(_ entities: [Entity]) -> [PlotDisplayItemViewModel] {
        var viewModels: [String: PlotDisplayItemViewModel] = [:]
        for entity in entities {
            guard let currDisplayName = ItemToViewDataMap
                .itemTypeToDisplayName[entity.type],
                  let currImageName = ItemToViewDataMap
                .itemTypeToImage[entity.type] else {
                continue
            }

            if let existingViewModel = viewModels[currDisplayName] {
                viewModels[currDisplayName] = PlotDisplayItemViewModel(
                    seedType: entity.type,
                    name: currDisplayName,
                    imageName: currImageName,
                    quantity: existingViewModel.quantity + 1
                )
            } else {
                viewModels[currDisplayName] = PlotDisplayItemViewModel(
                    seedType: entity.type,
                    name: currDisplayName,
                    imageName: currImageName,
                    quantity: 1
                )
            }
        }
        return viewModels.values.sorted { $0.name < $1.name }
    }
}
