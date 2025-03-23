//
//  UnsackableItemComponent.swift
//  Ah Leongs FarmTests
//
//  Created by Lester Ong on 23/3/25.
//

import Foundation
import XCTest
@testable import Ah_Leongs_Farm

class UnstackableItemComponent: ItemComponent {
    override var stackable: Bool {
        false
    }
}
