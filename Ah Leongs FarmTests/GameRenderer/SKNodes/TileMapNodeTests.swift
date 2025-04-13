//
//  TileMapNodeTests.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 6/4/25.
//

import XCTest
import SpriteKit
@testable import Ah_Leongs_Farm

class TileMapNodeTests: XCTestCase {
    var tileMapNode: TileMapNode!

    override func setUp() {
        super.setUp()
        tileMapNode = TileMapNode(tileSet: SKTileSet(), columns: 10, rows: 10, tileSize: CGSize(width: 32, height: 32))
    }

    override func tearDown() {
        tileMapNode = nil
        super.tearDown()
    }

    func testIsRowValid() {
        XCTAssertTrue(tileMapNode.isRowValid(0))
        XCTAssertTrue(tileMapNode.isRowValid(9))
        XCTAssertFalse(tileMapNode.isRowValid(-1))
        XCTAssertFalse(tileMapNode.isRowValid(10))
    }

    func testIsColumnValid() {
        XCTAssertTrue(tileMapNode.isColumnValid(0))
        XCTAssertTrue(tileMapNode.isColumnValid(9))
        XCTAssertFalse(tileMapNode.isColumnValid(-1))
        XCTAssertFalse(tileMapNode.isColumnValid(10))
    }

    func testFillWithTileGroupName() {
        let tileGroup = SKTileGroup()
        tileGroup.name = "TestTileGroup"
        tileMapNode.tileSet = SKTileSet(tileGroups: [tileGroup])

        tileMapNode.fill(with: "TestTileGroup")

        for row in 0..<tileMapNode.numberOfRows {
            for column in 0..<tileMapNode.numberOfColumns {
                XCTAssertEqual(tileMapNode.tileGroup(atColumn: column, row: row)?.name, "TestTileGroup")
            }
        }
    }

    func testLightUpTile() {
        tileMapNode.lightUpTile(atRow: 0, column: 0, color: .red, blendFactor: 0.5)

        XCTAssertEqual(tileMapNode.children.count, 1)
        if let colorNode = tileMapNode.children.first as? SKSpriteNode {
            XCTAssertEqual(colorNode.color, .red)
            XCTAssertEqual(colorNode.colorBlendFactor, 0.5)
            XCTAssertEqual(colorNode.position, tileMapNode.centerOfTile(atColumn: 0, row: 0))
        } else {
            XCTFail("Expected a SKSpriteNode as the first child")
        }
    }

    func testRemoveAllLightUpTiles() {
        tileMapNode.lightUpTile(atRow: 0, column: 0, color: .red, blendFactor: 0.5)
        tileMapNode.lightUpTile(atRow: 1, column: 1, color: .blue, blendFactor: 0.5)

        tileMapNode.removeAllLightUpTiles()

        XCTAssertEqual(tileMapNode.children.count, 0)
    }
}
