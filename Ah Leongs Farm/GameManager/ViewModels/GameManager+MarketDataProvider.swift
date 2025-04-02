//
//  GameManager+MarketDataProvider.swift
//  Ah Leongs Farm
//
//  Created by proglab on 1/4/25.
//

extension GameManager {
    func getBuyItemViewModels() -> [BuyItemViewModel] {
        // Retrieve the MarketSystem from the game world or entity manager.
        guard let marketSystem = gameWorld.getSystem(ofType: MarketSystem.self) else {
            print("MarketSystem not found.")
            return []
        }

        var viewModels: [BuyItemViewModel] = []

        // Iterate over each item type and its price from the MarketSystem.
        let itemPrices = marketSystem.getItemPrices()
        for (itemType, price) in itemPrices {
            // Get the buy price for .coin currency.
            guard let buyPrice = price.buyPrice[.coin] else {
                print("Buy price missing for \(itemType)")
                continue
            }
    
            // Retrieve the display name and image name from your mapping.
            guard let name = ItemToViewDataMap.itemTypeToDisplayName[itemType],
                  let imageName = ItemToViewDataMap.itemTypeToImage[itemType] else {
                fatalError("Missing display data for \(itemType)")
            }
            
            let viewModel = BuyItemViewModel(
                name: name,
                imageName: imageName,
                buyPrice: buyPrice,
                quantity: marketSystem.getBuyQuantity(for: itemType) ?? 0,
                itemType: itemType
            )
            viewModels.append(viewModel)
        }

        // Sort view models alphabetically by name.
        return viewModels.sorted { $0.name < $1.name }
    }

    func getSellItemViewModels() -> [SellItemViewModel] {
            // Retrieve the MarketSystem from the game world.
            guard let marketSystem = gameWorld.getSystem(ofType: MarketSystem.self) else {
                return []
            }
            
            var viewModels: [SellItemViewModel] = []
            
            // Iterate over every item type that is sellable, as defined in MarketInformation.
            for itemType in MarketInformation.sellableItems {
                // Retrieve the sell price using the MarketSystem helper.
                guard let sellPrice = marketSystem.getSellPrice(for: itemType, currency: .coin) else {
                    print("Sell price missing for \(itemType)")
                    continue
                }

                // Retrieve the quantity using the MarketSystem helper.
                let quantity = marketSystem.getSellQuantity(for: itemType)

                // Get the display name and image from the mapping.
                guard let name = ItemToViewDataMap.itemTypeToDisplayName[itemType],
                      let imageName = ItemToViewDataMap.itemTypeToImage[itemType] else {
                    fatalError("Missing display data for \(itemType)")
                }

                let viewModel = SellItemViewModel(
                    name: name,
                    imageName: imageName,
                    sellPrice: sellPrice,
                    quantity: quantity,
                    itemType: itemType
                )

                viewModels.append(viewModel)
            }

        // Return the view models sorted by quantity
        return viewModels.sorted { $0.quantity > $1.quantity }
        }
}
