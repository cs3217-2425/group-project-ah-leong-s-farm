//
//  EventDispatcher.swift
//  Ah Leongs Farm
//
//  Created by proglab on 25/3/25.
//

protocol EventQueueable: AnyObject {
    func queueEvent(_ event: GameEvent)
}
