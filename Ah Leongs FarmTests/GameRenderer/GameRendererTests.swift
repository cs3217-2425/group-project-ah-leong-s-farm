import XCTest
import SpriteKit
@testable import Ah_Leongs_Farm

class GameRendererTests: XCTestCase {

    func testInit() {
        let gameScene = GameScene(view: SKView())
        let gameRenderer = GameRenderer()
        gameRenderer.setScene(gameScene)
        XCTAssertNotNil(gameRenderer)
    }

    func testNotifyAddsNodesToScene() {
        let gameScene = GameScene(view: SKView())
        let gameRenderer = GameRenderer()
        gameRenderer.setScene(gameScene)

        let entity = EntityAdapter()
        let gridComponent = GridComponent(rows: 3, columns: 3)
        let renderComponent = RenderComponent(updatable: true)
        entity.addComponent(gridComponent)
        entity.addComponent(renderComponent)
        let entities = [entity]

        gameRenderer.observe(entities: entities)

        XCTAssertEqual(gameScene.children.count, 1)
    }

    func testNotifyDoesNotAddDuplicateNodes() {
        let gameScene = GameScene(view: SKView())
        let gameRenderer = GameRenderer()
        gameRenderer.setScene(gameScene)

        let entity = EntityAdapter()
        let gridComponent = GridComponent(rows: 3, columns: 3)
        let renderComponent = RenderComponent(updatable: true)
        entity.addComponent(gridComponent)
        entity.addComponent(renderComponent)
        let entities = [entity]

        gameRenderer.observe(entities: entities)
        gameRenderer.observe(entities: entities)

        XCTAssertEqual(gameScene.children.count, 1)
    }

    func testSetRenderNodeForTileMapNode() {
        let gameScene = GameScene(view: SKView())
        let gameRenderer = GameRenderer()
        gameRenderer.setScene(gameScene)

        let entity = EntityAdapter()
        let entityIdentifier = ObjectIdentifier(entity)
        let tileMapNode = TileMapNode()

        gameRenderer.setRenderNode(for: entityIdentifier, node: tileMapNode)

        XCTAssertEqual(gameScene.children.count, 1)
        XCTAssertEqual(gameRenderer.allRenderNodes.count, 1)
    }

    func testSetRenderNodeForSpriteNode() {
        let gameScene = GameScene(view: SKView())
        let gameRenderer = GameRenderer()
        gameRenderer.setScene(gameScene)

        let entity = EntityAdapter()
        let entityIdentifier = ObjectIdentifier(entity)
        let spriteNode = SpriteNode()

        gameRenderer.setRenderNode(for: entityIdentifier, node: spriteNode)

        XCTAssertEqual(gameScene.children.count, 1)
        XCTAssertEqual(gameRenderer.allRenderNodes.count, 1)
    }

    func testLightUpTile() {
        let gameScene = GameScene(view: SKView())
        let gameRenderer = GameRenderer()
        gameRenderer.setScene(gameScene)

        let tileMapNode = TileMapNode()
        tileMapNode.numberOfRows = 3
        tileMapNode.numberOfColumns = 3
        let entity = EntityAdapter()
        gameRenderer.setRenderNode(for: ObjectIdentifier(entity), node: tileMapNode)

        gameRenderer.lightUpTile(at: 0, column: 0)

        XCTAssertEqual(tileMapNode.lightUpNodes.count, 1)
    }

    func testUnlightAllTiles() {
        let gameScene = GameScene(view: SKView())
        let gameRenderer = GameRenderer()
        gameRenderer.setScene(gameScene)

        let tileMapNode = TileMapNode()
        tileMapNode.numberOfRows = 3
        tileMapNode.numberOfColumns = 3
        let entity = EntityAdapter()
        gameRenderer.setRenderNode(for: ObjectIdentifier(entity), node: tileMapNode)

        gameRenderer.lightUpTile(at: 0, column: 0)
        gameRenderer.unlightAllTiles()

        XCTAssertTrue(tileMapNode.lightUpNodes.isEmpty)
    }
}
