//
//  QuestCriteria.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 20/3/25.
//

protocol QuestCriteria {
    func calculateValue(from eventData: EventData) -> Float
}

/*
 Calculates the quest progress based on harvested crop quantity,
 ensuring the event data matches the required crop type.
 */
struct HarvestCropCriteria: QuestCriteria {
    let cropType: CropType

    func calculateValue(from eventData: EventData) -> Float {

        guard let harvestData = eventData as? HarvestCropEventData else {
            return 0
        }

        guard harvestData.type == cropType else {
            return 0
        }

        return Float(harvestData.quantity)
    }
}

/*
 Calculates the quest progress based on the number of turns survived,
 ensuring the event data corresponds to end turn event.
 */
struct SurviveNumberOfTurnsCriteria: QuestCriteria {

    func calculateValue(from eventData: EventData) -> Float {
        guard let endTurnData = eventData as? EndTurnEventData else {
            return 0
        }

        return Float(endTurnData.endTurnCount)
    }
}

/*
 Calculates the quest progress based on sold crop quantity,
 ensuring the event data matches the required crop type.
 */
struct SellCropCriteria: QuestCriteria {
    let cropType: CropType

    func calculateValue(from eventData: EventData) -> Float {

        guard let sellData = eventData as? SellCropEventData else {
            return 0
        }

        guard sellData.type == cropType else {
            return 0
        }
        return Float(sellData.quantity)
    }
}
