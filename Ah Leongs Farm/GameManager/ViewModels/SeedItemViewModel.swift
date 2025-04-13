//
//  SeedItemViewModel.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 2/4/25.
//

struct SeedItemViewModel {
    let cropType: CropType
    let name: String
    let imageName: String
    let quantity: Int

    init?(cropType: CropType, name: String, imageName: String, quantity: Int) {
        self.cropType = cropType
        self.name = name
        self.imageName = imageName
        self.quantity = quantity
    }

    func toInventoryItemViewModel() -> InventoryItemViewModel {
        InventoryItemViewModel(name: name, imageName: imageName, quantity: quantity)
    }
}
