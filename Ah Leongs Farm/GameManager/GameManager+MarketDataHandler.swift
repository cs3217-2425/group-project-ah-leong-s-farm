//
//  GameManager+MarketDataHandler.swift
//  Ah Leongs Farm
//
//  Created by proglab on 1/4/25.
//

extension GameManager: MarketDataHandler {
    func getBuyItemViewModels() -> [BuyItemViewModel] {

        guard let marketSystem = gameWorld.getSystem(ofType: MarketSystem.self) else {
            print("MarketSystem not found.")
            return []
        }

        var viewModels: [BuyItemViewModel] = []

        let itemPrices = marketSystem.getItemPrices()
        for (itemType, price) in itemPrices {
            guard let buyPrice = price.buyPrice[.coin] else {
                print("Buy price missing for \(itemType)")
                continue
            }

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

        return viewModels.sorted { $0.name < $1.name }
    }

    func getSellItemViewModels() -> [SellItemViewModel] {
        guard let marketSystem = gameWorld.getSystem(ofType: MarketSystem.self) else {
            return []
        }

        var viewModels: [SellItemViewModel] = []

        for itemType in MarketInformation.sellableItems {

            guard let sellPrice = marketSystem.getSellPrice(for: itemType, currency: .coin) else {
                print("Sell price missing for \(itemType)")
                continue
            }

            let quantity = marketSystem.getSellQuantity(for: itemType)

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

        return viewModels.sorted { $0.quantity > $1.quantity }
    }

    func buyItem(itemType: ItemType, quantity: Int, currency: CurrencyType = .coin) {
        gameWorld.queueEvent(BuyItemEvent(itemType: itemType, quantity: quantity, currencyType: currency))
    }

    func sellItem(itemType: ItemType, quantity: Int, currency: CurrencyType = .coin) {
        gameWorld.queueEvent(SellItemEvent(itemType: itemType, quantity: quantity, currencyType: currency))
    }

    func getAmountOfCurrencyForMarket(_ currency: CurrencyType) -> Double {
        guard let currencySystem = gameWorld.getSystem(ofType: WalletSystem.self) else {
            return 0
        }

        return currencySystem.getTotalAmount(of: .coin)
    }
}
