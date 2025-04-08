//
//  SpriteRenderManagerTests.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 6/4/25.
//

import XCTest
@testable import Ah_Leongs_Farm

class SpriteRenderManagerTests: XCTestCase {
    var spriteRenderManager: SpriteRenderManager!
    var mockRenderer: MockGameRenderer!
    var mockUIPositionProvider: MockUIPositionProvider!

    override func setUp() {
        super.setUp()
        mockUIPositionProvider = MockUIPositionProvider()
        spriteRenderManager = SpriteRenderManager(uiPositionProvider: mockUIPositionProvider)
        mockRenderer = MockGameRenderer()
    }

    override func tearDown() {
        spriteRenderManager = nil
        mockRenderer = nil
        mockUIPositionProvider = nil
        super.tearDown()
    }

    func testCreateNodeForEntity_Plot() {
        let plot = Plot(position: CGPoint(x: 1, y: 1))
        spriteRenderManager.createNode(for: plot, in: mockRenderer)

        XCTAssertTrue(mockRenderer.didSetRenderNode)
        XCTAssertEqual(mockRenderer.renderNodeIdentifier, ObjectIdentifier(plot))
        XCTAssertNotNil(mockRenderer.renderNode)
    }

    func testCreateNodeForEntity_Apple() {
        let row = 1
        let column = 1
        let apple = Apple()

        apple.addComponent(PositionComponent(x: CGFloat(row), y: CGFloat(column)))
        apple.addComponent(SpriteComponent(visitor: apple))

        mockUIPositionProvider.row = row
        mockUIPositionProvider.column = column

        spriteRenderManager.createNode(for: apple, in: mockRenderer)

        XCTAssertTrue(mockRenderer.didSetRenderNode)
        XCTAssertEqual(mockRenderer.renderNodeIdentifier, ObjectIdentifier(apple))
        XCTAssertNotNil(mockRenderer.renderNode)
    }

    func testCreateNodeForEntity_BokChoy() {
        let row = 1
        let column = 1
        let bokChoy = BokChoy()

        bokChoy.addComponent(PositionComponent(x: CGFloat(row), y: CGFloat(column)))
        bokChoy.addComponent(SpriteComponent(visitor: bokChoy))

        mockUIPositionProvider.row = row
        mockUIPositionProvider.column = column

        spriteRenderManager.createNode(for: bokChoy, in: mockRenderer)

        XCTAssertTrue(mockRenderer.didSetRenderNode)
        XCTAssertEqual(mockRenderer.renderNodeIdentifier, ObjectIdentifier(bokChoy))
        XCTAssertNotNil(mockRenderer.renderNode)
    }

    func testCreateNodeForEntity_Potato() {
        let row = 1
        let column = 1
        let potato = Potato()

        potato.addComponent(PositionComponent(x: CGFloat(row), y: CGFloat(column)))
        potato.addComponent(SpriteComponent(visitor: potato))

        mockUIPositionProvider.row = row
        mockUIPositionProvider.column = column

        spriteRenderManager.createNode(for: potato, in: mockRenderer)

        XCTAssertTrue(mockRenderer.didSetRenderNode)
        XCTAssertEqual(mockRenderer.renderNodeIdentifier, ObjectIdentifier(potato))
        XCTAssertNotNil(mockRenderer.renderNode)
    }
}

// Mock classes
class MockGameRenderer: GameRenderer {
    var didSetRenderNode = false
    var renderNodeIdentifier: ObjectIdentifier?
    var renderNode: SpriteNode?

    override func setRenderNode(for identifier: ObjectIdentifier, node: SpriteNode) {
        didSetRenderNode = true
        renderNodeIdentifier = identifier
        renderNode = node
    }
}

class MockUIPositionProvider: UIPositionProvider {
    var row: Int = 0
    var column: Int = 0

    func getRowAndColumn(fromPosition location: CGPoint) -> (row: Int, column: Int)? {
        (row, column)
    }

    func getUIPosition(row: Int, column: Int) -> CGPoint? {
        CGPoint(x: row, y: column)
    }
}
