//
//  EventDispatcher.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 17/3/25.
//

class EventDispatcher {
    private var eventQueue: [GameEvent] = []
    private weak var context: EventContext?

    init(context: EventContext) {
        self.context = context
    }

    func queueEvent(_ event: GameEvent) {
        eventQueue.append(event)
    }

    func processEvents() {
        guard let context = context else { return }

        // Take a copy of the current queue
        // This prevents concurrent modification of the event queue
        // as an event could queue additional events.
        let currentEvents = eventQueue
        eventQueue.removeAll()

        for event in currentEvents {
            event.execute(in: context)
        }

        if !eventQueue.isEmpty {
            processEvents()
        }
    }
}
