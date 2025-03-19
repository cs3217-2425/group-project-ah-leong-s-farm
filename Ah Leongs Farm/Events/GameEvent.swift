//
//  GameEvent.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 17/3/25.
//

protocol GameEvent {
    func execute(in context: EventContext)
}
