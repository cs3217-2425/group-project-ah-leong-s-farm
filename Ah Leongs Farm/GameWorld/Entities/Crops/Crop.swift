//
//  Crop.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 27/3/25.
//

import Foundation
import GameplayKit

protocol Crop: GKEntity {
    var seedItemType: ItemType { get }
    var harvestedItemType: ItemType { get }
    var components: [GKComponent] { get }
}
