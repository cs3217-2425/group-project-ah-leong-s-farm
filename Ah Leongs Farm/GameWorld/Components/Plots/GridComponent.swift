//
//  GridComponent.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 15/3/25.
//

import Foundation

class GridComponent: ComponentAdapter {
    private var matrix: [[Entity?]]

    let numberOfRows: Int
    let numberOfColumns: Int

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    init(rows numberOfRows: Int, columns numberOfColumns: Int) {
        matrix = Array(repeating: Array(repeating: nil, count: numberOfColumns), count: numberOfRows)
        self.numberOfRows = numberOfRows
        self.numberOfColumns = numberOfColumns
        super.init()
    }

    func setEntity(_ entity: Entity?, row: Int, column: Int) {
        guard isRowValid(row), isColumnValid(column) else {
            return
        }

        matrix[row][column] = entity
    }

    func getEntity(row: Int, column: Int) -> Entity? {
        guard isRowValid(row), isColumnValid(column) else {
            return nil
        }

        return matrix[row][column]
    }

    private func isRowValid(_ row: Int) -> Bool {
        row >= 0 && row < numberOfRows
    }

    private func isColumnValid(_ column: Int) -> Bool {
        column >= 0 && column < numberOfColumns
    }
}
