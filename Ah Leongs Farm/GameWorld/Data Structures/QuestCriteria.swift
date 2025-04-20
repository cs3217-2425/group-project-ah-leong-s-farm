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
 Calculates the quest progress based on planted crop quantity,
 ensuring the event data matches the required crop type.
 */
struct PlantCropCriteria: QuestCriteria {
    let cropType: EntityType

    func calculateValue(from eventData: EventData) -> Float {

        guard let plantData = eventData as? PlantCropEventData else {
            return 0
        }

        guard plantData.cropType == cropType else {
            return 0
        }

        return Float(1)
    }
}

/*
 Calculates the quest progress based on harvested crop quantity,
 ensuring the event data matches the required crop type.
 */
struct HarvestCropCriteria: QuestCriteria {
    let cropType: EntityType

    func calculateValue(from eventData: EventData) -> Float {

        guard let harvestData = eventData as? HarvestCropEventData else {
            return 0
        }

        guard harvestData.cropType == cropType else {
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
struct SellItemCriteria: QuestCriteria {
    let itemType: EntityType

    func calculateValue(from eventData: EventData) -> Float {

        guard let sellData = eventData as? SellItemEventData else {
            return 0
        }

        guard sellData.itemType == itemType else {
            return 0
        }
        return Float(sellData.quantity)
    }
}

struct AddPlotCriteria: QuestCriteria {
    func calculateValue(from eventData: EventData) -> Float {
        guard eventData is AddPlotEventData else {
            return 0
        }

        return 1
    }
}

struct WaterPlotCriteria: QuestCriteria {
    func calculateValue(from eventData: EventData) -> Float {
        guard let waterPlotData = eventData as? WaterPlotEventData,
              waterPlotData.isSuccessfullyWatered == true else {
            return 0
        }
        return 1
    }
}

struct UseFertiliserCriteria: QuestCriteria {
    let fertiliserType: EntityType
    func calculateValue(from eventData: EventData) -> Float {
        guard let useFertiliserData = eventData as? UseFertiliserEventData,
              useFertiliserData.fertiliserType == fertiliserType else {
            return 0
        }
        return 1
    }
}

struct AddSolarPanelCriteria: QuestCriteria {
    func calculateValue(from eventData: EventData) -> Float {
        guard eventData is AddSolarPanelEventData else {
            return 0
        }
        return 1
    }
}
