//
//  IGameProvicer.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 27/3/25.
//

protocol IGameProvider {
    var gameManager: GameManager { get }
    var gameRenderer: GameRenderer { get }
}
