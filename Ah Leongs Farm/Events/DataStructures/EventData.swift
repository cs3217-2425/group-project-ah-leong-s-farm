//
//  EventData.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 20/3/25.
//

struct EventData {
    let eventType: EventType
    // Make value hashable for simpler equality checks
    var data: [EventDataType: any Hashable] = [:]

    mutating func addData(type: EventDataType, value: any Hashable) {
        data[type] = value
    }
}

enum EventDataType {
    case endTurnCount
    case cropType
    case cropAmount
    case xpGrantAmount
    case currencyGrant
    case currencyGrantAmount
    case itemGrant
    case itemGrantQuantity
}
