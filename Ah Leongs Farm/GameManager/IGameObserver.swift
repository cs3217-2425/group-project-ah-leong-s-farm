//
//  IGameObserver.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 18/3/25.
//

import GameplayKit

protocol IGameObserver: AnyObject {
    func observe(entities: Set<GKEntity>)
}
