//
//  GridComponent.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 15/3/25.
//

import GameplayKit

class GridComponent: GKComponent {
    private var matrix: [[GKEntity?]]

    let numberOfRows: Int
    let numberOfColumns: Int

    required init?(coder: NSCoder) {
        matrix = []
        numberOfRows = 0
        numberOfColumns = 0
        super.init(coder: coder)
    }

    init(rows numberOfRows: Int, columns numberOfColumns: Int) {
        matrix = Array(repeating: Array(repeating: nil, count: numberOfColumns), count: numberOfRows)
        self.numberOfRows = numberOfRows
        self.numberOfColumns = numberOfColumns
        super.init()
    }

    func setEntity(_ entity: GKEntity?, row: Int, column: Int) {
        guard isRowValid(row), isColumnValid(column) else {
            return
        }

        matrix[row][column] = entity
    }

    func getEntity(row: Int, column: Int) -> GKEntity? {
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
