//
//  SKTileMapNode+Extension.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 29/3/25.
//

import SpriteKit

extension SKTileMapNode {
    func isRowValid(_ row: Int) -> Bool {
        row >= 0 && row < numberOfRows
    }

    func isColumnValid(_ column: Int) -> Bool {
        column >= 0 && column < numberOfColumns
    }
}
