//
//  Seed.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 13/4/25.
//

import Foundation

protocol Seed: SpriteRenderManagerVisitor where Self: EntityAdapter {
    func toCrop() -> Crop
}
