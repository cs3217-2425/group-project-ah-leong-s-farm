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
}
