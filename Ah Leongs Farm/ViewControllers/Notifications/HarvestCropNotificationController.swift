//
//  LevelUpNotificationController 2.swift
//  Ah Leongs Farm
//
//  Created by proglab on 20/4/25.
//

class HarvestCropNotificationController {

    private let notificationManager: NotificationManager

    init(notificationManager: NotificationManager) {
        self.notificationManager = notificationManager
    }

    func onHarvest(_ type: EntityType, _ quantity: Int) {
        notificationManager.showNotification(
            title: "Crop Harvested!",
            message: "Added \(quantity) \(ItemToViewDataMap.itemTypeToDisplayName[type] ?? "Crops")"
        )
    }
}

extension HarvestCropNotificationController: IEventObserver {
    func onEvent(_ eventData: EventData) {
        if let harvestData = eventData as? HarvestCropEventData {
            onHarvest(harvestData.cropType, harvestData.quantity)
        }
    }
}
