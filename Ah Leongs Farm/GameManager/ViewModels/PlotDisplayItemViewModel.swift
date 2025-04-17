//
//  SeedItemViewModel.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 2/4/25.
//

struct PlotDisplayItemViewModel {
    let type: EntityType
    let name: String
    let imageName: String
    let quantity: Int

    init?(seedType: EntityType, name: String, imageName: String, quantity: Int) {
        self.type = seedType
        self.name = name
        self.imageName = imageName
        self.quantity = quantity
    }

    func toInventoryItemViewModel() -> InventoryItemViewModel {
        InventoryItemViewModel(name: name, imageName: imageName, quantity: quantity)
    }
}
