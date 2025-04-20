//
//  QuestPathID.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 20/4/25.
//

import Foundation
struct QuestPathIDs {
    let tutorial = TutorialPathIDs()
    let vegetables = VegetablePathIDs()
    let fruits = FruitPathIDs()
    let market = MarketPathIDs()
    let technology = TechnologyPathIDs()
    let pro = ProPathIDs()

    struct TutorialPathIDs {
        let firstSteps = UUID()
        let farmFoundations = UUID()
    }

    struct VegetablePathIDs {
        let apprentice = UUID()
        let greenThumb = UUID()
        let pro = UUID()
    }

    struct FruitPathIDs {
        let orchardKeeper = UUID()
        let fruitEnthusiast = UUID()
        let pomologist = UUID()
    }

    struct MarketPathIDs {
        let novice = UUID()
        let trader = UUID()
        let mogul = UUID()
    }

    struct TechnologyPathIDs {
        let pioneer = UUID()
        let solarFarmer = UUID()
    }

    struct ProPathIDs {
        let sustainableFarming = UUID()
        let farmEmpire = UUID()
        let agriculturalLegend = UUID()
    }
}
