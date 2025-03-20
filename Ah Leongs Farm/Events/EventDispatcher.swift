//
//  EventDispatcher.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 17/3/25.
//

class EventDispatcher {
    private var eventQueue: Queue<GameEvent> = Queue()
    private var eventObservers: [EventObserver]
    private weak var context: EventContext?

    init(context: EventContext) {
        self.context = context
        self.eventObservers = []
    }

    func queueEvent(_ event: GameEvent) {
        eventQueue.enqueue(event)
    }

    func addEventObserver(_ observer: EventObserver) {
        eventObservers.append(observer)
    }

    func processEvents() {
        guard let context = context else {
            return
        }

        // Maintain a counter such that we only execute events in the initial queue
        // (and not any additional events queued by other events)
        var currentEventCount = eventQueue.count
        while currentEventCount > 0 {
            guard let event = eventQueue.dequeue() else {
                fatalError("EventDispatcher.processEvents() dequeued an empty EventQueue")
            }

            // Execute the event, then notify observers if data is obtained from the execution.
            if let eventData = event.execute(in: context) {
                for observer in eventObservers {
                    observer.onEvent(eventData)
                }
            }
            currentEventCount -= 1
        }
    }
}
