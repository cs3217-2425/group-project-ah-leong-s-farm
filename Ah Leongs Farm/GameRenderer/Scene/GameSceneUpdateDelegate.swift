//
//  GameSceneUpdateDelegate.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 26/3/25.
//

import Foundation

protocol GameSceneUpdateDelegate: AnyObject {
    func update(_ timeInterval: TimeInterval)
}
