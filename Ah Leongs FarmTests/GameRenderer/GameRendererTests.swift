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
}
