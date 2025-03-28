//
//  UIPositionProvider.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 28/3/25.
//

import Foundation

/// A protocol that provides methods to convert between UI positions and tile map coordinates.
protocol UIPositionProvider: AnyObject {

    /// Converts a row and column index to a CGPoint representing the position in the UI.
    ///
    /// - Parameters:
    ///   - row: The row index of the tile.
    ///   - column: The column index of the tile.
    /// - Returns: A CGPoint representing the position in the UI, or nil if the row or column is invalid.
    func getUIPosition(row: Int, column: Int) -> CGPoint?

    /// Converts a touch position in the UI to a row and column index in the tile map.
    ///
    /// - Parameter touchPosition: The CGPoint representing the touch position in the UI.
    /// - Returns: A tuple containing the row and column index, or nil if the touch position is invalid.
    func getSelectedRowAndColumn(at touchPosition: CGPoint) -> (Int, Int)?
}
