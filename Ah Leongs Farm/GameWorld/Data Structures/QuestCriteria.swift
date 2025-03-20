//
//  QuestCriteria.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 20/3/25.
//

struct QuestCriteria {
    let eventType: EventType
    let requiredData: [EventDataType: any Hashable]
    let progressCalculator: ProgressCalculator

    init(eventType: EventType,
         requiredData: [EventDataType: any Hashable] = [:],
         progressCalculator: ProgressCalculator
    ) {
        self.eventType = eventType
        self.requiredData = requiredData
        self.progressCalculator = progressCalculator
    }
}
