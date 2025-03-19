//
//  EventDispatcher.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 17/3/25.
//

class EventDispatcher {
    private var eventQueue: Queue<GameEvent> = Queue()
    private weak var context: EventContext?

    init(context: EventContext) {
        self.context = context
    }

    func queueEvent(_ event: GameEvent) {
        eventQueue.enqueue(event)
    }

    func processEvents() {
        guard let context = context else { return }

        // Maintain a counter such that we only execute events in the initial queue
        // (and not any additional events queued by other events)
        var currentEventCount = eventQueue.count
        while currentEventCount > 0 {
            guard let event = eventQueue.dequeue() else {
                fatalError("EventDispatcher.processEvents() dequeued an empty EventQueue")
            }
            event.execute(in: context)

            currentEventCount -= 1
        }
    }
}
