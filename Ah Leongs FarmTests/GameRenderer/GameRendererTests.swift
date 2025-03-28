import XCTest
import GameplayKit
@testable import Ah_Leongs_Farm

class GameRendererTests: XCTestCase {

    func testInit() {
        let scene = SKScene(size: CGSize(width: 100, height: 100))
        let gameRenderer = GameRenderer(scene: scene)

        XCTAssertNotNil(gameRenderer)
    }

    func testNotifyAddsNodesToScene() {
        let scene = SKScene(size: CGSize(width: 100, height: 100))
        let gameRenderer = GameRenderer(scene: scene)
        let gameWorld = GameWorld()

        let entity = GKEntity()
        let gridComponent = GridComponent(rows: 3, columns: 3)
        entity.addComponent(gridComponent)
        gameWorld.addEntity(entity)

        gameRenderer.notify(gameWorld)

        XCTAssertEqual(scene.children.count, 1)
    }

    func testNotifyDoesNotAddDuplicateNodes() {
        let scene = SKScene(size: CGSize(width: 100, height: 100))
        let gameRenderer = GameRenderer(scene: scene)
        let gameWorld = GameWorld()

        let entity = GKEntity()
        let gridComponent = GridComponent(rows: 3, columns: 3)
        entity.addComponent(gridComponent)
        gameWorld.addEntity(entity)

        gameRenderer.notify(gameWorld)
        gameRenderer.notify(gameWorld)

        XCTAssertEqual(scene.children.count, 1)
    }

    func testGetSelectedRowAndColumn() {
        guard let tileSet = SKTileSet(named: "Farm Tile Set") else {
            XCTFail("Could not load tile set")
            return
        }

        let sceneSize = CGSize(width: 144, height: 144)
        let tileSize = CGSize(width: 48, height: 48)

        let scene = SKScene(size: sceneSize)
        let gameRenderer = GameRenderer(scene: scene)

        // No tile at CGPoint(x: -0.1, y: 0)
        var touchPosition = CGPoint(x: -0.1, y: 0)
        var selectedRowAndColumn = gameRenderer.getSelectedRowAndColumn(at: touchPosition)
        XCTAssertNil(selectedRowAndColumn)

        // Test tile at row 0, column 0
        touchPosition = CGPoint(x: 0, y: 0)
        selectedRowAndColumn = gameRenderer.getSelectedRowAndColumn(at: touchPosition)
        XCTAssertEqual(selectedRowAndColumn?.0, 0)
        XCTAssertEqual(selectedRowAndColumn?.1, 0)

        // Test tile at row 1, column 1
        touchPosition = CGPoint(x: 72, y: 72)
        selectedRowAndColumn = gameRenderer.getSelectedRowAndColumn(at: touchPosition)
        XCTAssertEqual(selectedRowAndColumn?.0, 1)
        XCTAssertEqual(selectedRowAndColumn?.1, 1)

        // Test tile at row 2, column 2
        touchPosition = CGPoint(x: 120, y: 120)
        selectedRowAndColumn = gameRenderer.getSelectedRowAndColumn(at: touchPosition)
        XCTAssertEqual(selectedRowAndColumn?.0, 2)
        XCTAssertEqual(selectedRowAndColumn?.1, 2)

        // No tile at CGPoint(x: 148, y: 148)
        touchPosition = CGPoint(x: 148, y: 148)
        selectedRowAndColumn = gameRenderer.getSelectedRowAndColumn(at: touchPosition)
        XCTAssertNil(selectedRowAndColumn)
    }
}
