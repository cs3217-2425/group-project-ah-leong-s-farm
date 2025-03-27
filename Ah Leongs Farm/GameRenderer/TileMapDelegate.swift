//
//  TileMapDelegate.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 27/3/25.
//

import Foundation

protocol TileMapDelegate: AnyObject {
    func getPosition(row: Int, column: Int) -> CGPoint?

    /// Get selected row and column from touch position
    /// Rows and columns are zero-indexed.
    /// - Parameter touchPosition: Touch position in the scene's coordinate system.
    func getSelectedRowAndColumn(at touchPosition: CGPoint) -> (Int, Int)?
}
