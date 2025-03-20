//
//  EventObserver.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 20/3/25.
//

protocol EventObserver: AnyObject {
    func onEvent(_ eventData: EventData)
}
