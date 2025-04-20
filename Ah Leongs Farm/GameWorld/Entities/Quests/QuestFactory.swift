//
//  QuestFactory.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 21/3/25.
//

import Foundation

class QuestFactory {
    // MARK: - Quest Objective Helpers

    static func createPlantCropObjective(type: EntityType, plantAmount: Int) -> QuestObjective {
        let plantCropCriteria = PlantCropCriteria(cropType: type)
        let displayName = ItemToViewDataMap.itemTypeToDisplayName[type] ?? ""

        return QuestObjective(
            description: "Plant \(plantAmount) \(displayName)s",
            criteria: plantCropCriteria,
            target: Float(plantAmount)
        )
    }

    static func createHarvestCropObjective(type: EntityType, harvestAmount: Int) -> QuestObjective {
        let harvestCropCriteria = HarvestCropCriteria(cropType: type)
        let displayName = ItemToViewDataMap.itemTypeToDisplayName[type] ?? ""
        return QuestObjective(
            description: "Harvest \(harvestAmount) \(displayName)s",
            criteria: harvestCropCriteria,
            target: Float(harvestAmount)
        )
    }

    static func createSellItemObjective(type: EntityType, sellAmount: Int) -> QuestObjective {
        let sellCropCriteria = SellItemCriteria(itemType: type)
        let displayName = ItemToViewDataMap.itemTypeToDisplayName[type]
        return QuestObjective(
            description: "Sell \(sellAmount) \(displayName ?? "Item")s",
            criteria: sellCropCriteria,
            target: Float(sellAmount)
        )
    }

    static func createSurvivalObjective(days: Int) -> QuestObjective {
        let survivalCriteria = SurviveNumberOfTurnsCriteria()
        return QuestObjective(
            description: "Survive for \(days) days",
            criteria: survivalCriteria,
            target: Float(days)
        )
    }

    // MARK: - Quest Creation System

    static func createAllQuests() -> [Quest] {
        // Create quest IDs for easier reference
        let questIDs = QuestPathIDs()

        // Create all quests and return them as a single array
        return [
            // Tutorial Path - Getting Started
            createFirstStepsQuest(id: questIDs.tutorial.firstSteps),
            createFarmFoundationsQuest(id: questIDs.tutorial.farmFoundations, prereqs: [questIDs.tutorial.firstSteps]),

            // Vegetable Path
            createVegetableApprenticeQuest(id: questIDs.vegetables.apprentice, prereqs: [questIDs.tutorial.farmFoundations]),
            createGreenThumbQuest(id: questIDs.vegetables.greenThumb, prereqs: [questIDs.vegetables.apprentice]),
            createVegetableMasterQuest(id: questIDs.vegetables.master, prereqs: [questIDs.vegetables.greenThumb]),

            // Fruit Path
            createOrchardKeeperQuest(id: questIDs.fruits.orchardKeeper, prereqs: [questIDs.tutorial.farmFoundations]),
            createFruitEnthusiastQuest(id: questIDs.fruits.fruitEnthusiast, prereqs: [questIDs.fruits.orchardKeeper]),
            createPomologistQuest(id: questIDs.fruits.pomologist, prereqs: [questIDs.fruits.fruitEnthusiast]),

            // Market Path
            createMarketNoviceQuest(id: questIDs.market.novice, prereqs: [questIDs.tutorial.farmFoundations]),
            createMarketTraderQuest(id: questIDs.market.trader, prereqs: [questIDs.market.novice]),
            createMarketMogulQuest(id: questIDs.market.mogul, prereqs: [questIDs.market.trader]),

            // Technology Path
            createTechPioneerQuest(id: questIDs.technology.pioneer, prereqs: [questIDs.tutorial.farmFoundations]),
            createSolarFarmerQuest(id: questIDs.technology.solarFarmer, prereqs: [questIDs.technology.pioneer]),

            // Mastery Quests - require completion of multiple paths
            createSustainableFarmingQuest(
                id: questIDs.mastery.sustainableFarming,
                prereqs: [questIDs.vegetables.greenThumb, questIDs.technology.solarFarmer]
            ),
            createFarmEmpireQuest(
                id: questIDs.mastery.farmEmpire,
                prereqs: [questIDs.market.mogul, questIDs.fruits.pomologist, questIDs.vegetables.master]
            ),
            createAgriculturalLegendQuest(
                id: questIDs.mastery.agriculturalLegend,
                prereqs: [questIDs.mastery.sustainableFarming, questIDs.mastery.farmEmpire]
            )
        ]
    }
}
