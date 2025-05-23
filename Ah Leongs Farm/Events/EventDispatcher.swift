//
//  EventDispatcher.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 17/3/25.
//

class EventDispatcher {
    private var eventQueue: Queue<GameEvent> = Queue()
    private var eventObservers: [IEventObserver]
    private weak var context: EventContext?
    private weak var queueable: EventQueueable?

    init(context: EventContext, queueable: EventQueueable) {
        self.context = context
        self.queueable = queueable
        self.eventObservers = []
    }

    func queueEvent(_ event: GameEvent) {
        eventQueue.enqueue(event)
    }

    func addEventObserver(_ observer: IEventObserver) {
        eventObservers.append(observer)
    }

    func processEvents() {
        guard let context = context else {
            return
        }

        guard let queueable = queueable else {
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
            if let eventData = event.execute(in: context, queueable: queueable) {
                for observer in eventObservers {
                    observer.onEvent(eventData)
                }
            }
            currentEventCount -= 1
        }
    }
}
