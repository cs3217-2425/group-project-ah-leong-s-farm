import XCTest
import SpriteKit
@testable import Ah_Leongs_Farm

class TileMapRenderNodeTests: XCTestCase {

    func testInit() {
        guard let tileSet = SKTileSet(named: "Farm Tile Set") else {
            XCTFail("Could not load tile set")
            return
        }

        let tileMapRenderNode = TileMapRenderNode(
            tileSet: tileSet,
            rows: 3,
            columns: 3,
            tileSize: CGSize(width: 48, height: 48)
        )

        XCTAssertNotNil(tileMapRenderNode)
        XCTAssertEqual(tileMapRenderNode.rows, 3)
        XCTAssertEqual(tileMapRenderNode.columns, 3)
    }

    func testRows() {
        guard let tileSet = SKTileSet(named: "Farm Tile Set") else {
            XCTFail("Could not load tile set")
            return
        }

        let tileMapRenderNode = TileMapRenderNode(
            tileSet: tileSet,
            rows: 3,
            columns: 3,
            tileSize: CGSize(width: 48, height: 48)
        )

        XCTAssertEqual(tileMapRenderNode.rows, 3)
    }

    func testColumns() {
        guard let tileSet = SKTileSet(named: "Farm Tile Set") else {
            XCTFail("Could not load tile set")
            return
        }

        let tileMapRenderNode = TileMapRenderNode(
            tileSet: tileSet,
            rows: 3,
            columns: 3,
            tileSize: CGSize(width: 48, height: 48)
        )

        XCTAssertEqual(tileMapRenderNode.columns, 3)
    }

    func testFill() {
        guard let tileSet = SKTileSet(named: "Farm Tile Set") else {
            XCTFail("Could not load tile set")
            return
        }

        let tileMapRenderNode = TileMapRenderNode(
            tileSet: tileSet,
            rows: 3,
            columns: 3,
            tileSize: CGSize(width: 48, height: 48)
        )

        tileMapRenderNode.fill(with: "Land")

        guard let skTileMapNode = tileMapRenderNode.skNode as? SKTileMapNode else {
            XCTFail("Could not cast tileMapRenderNode's skNode as SKTileMapNode")
            return
        }

        // Check if the tile group is set
        XCTAssertEqual(skTileMapNode.tileSet.tileGroups.first?.name, "Land")
    }

    func testGetSelectedRowAndColumn() {
        guard let tileSet = SKTileSet(named: "Farm Tile Set") else {
            XCTFail("Could not load tile set")
            return
        }

        let sceneSize = CGSize(width: 144, height: 144)
        let tileSize = CGSize(width: 48, height: 48)

        let tileMapRenderNode = TileMapRenderNode(tileSet: tileSet, rows: 3, columns: 3, tileSize: tileSize)
        let scene = SKScene(size: sceneSize)
        scene.addChild(tileMapRenderNode.skNode)

        // No tile at CGPoint(x: -0.1, y: 0)
        var touchPosition = CGPoint(x: -0.1, y: 0)
        var selectedRowAndColumn = tileMapRenderNode.getSelectedRowAndColumn(at: touchPosition)
        XCTAssertNil(selectedRowAndColumn)

        // Test tile at row 0, column 0
        touchPosition = CGPoint(x: 0, y: 0)
        selectedRowAndColumn = tileMapRenderNode.getSelectedRowAndColumn(at: touchPosition)
        XCTAssertEqual(selectedRowAndColumn?.0, 0)
        XCTAssertEqual(selectedRowAndColumn?.1, 0)

        // Test tile at row 1, column 1
        touchPosition = CGPoint(x: 72, y: 72)
        selectedRowAndColumn = tileMapRenderNode.getSelectedRowAndColumn(at: touchPosition)
        XCTAssertEqual(selectedRowAndColumn?.0, 1)
        XCTAssertEqual(selectedRowAndColumn?.1, 1)

        // Test tile at row 2, column 2
        touchPosition = CGPoint(x: 120, y: 120)
        selectedRowAndColumn = tileMapRenderNode.getSelectedRowAndColumn(at: touchPosition)
        XCTAssertEqual(selectedRowAndColumn?.0, 2)
        XCTAssertEqual(selectedRowAndColumn?.1, 2)

        // No tile at CGPoint(x: 148, y: 148)
        touchPosition = CGPoint(x: 148, y: 148)
        selectedRowAndColumn = tileMapRenderNode.getSelectedRowAndColumn(at: touchPosition)
        XCTAssertNil(selectedRowAndColumn)
    }
}
