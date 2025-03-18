import SpriteKit

class GameScene: SKScene {
    private var gameManager: GameManager?
    private var gameCamera: GameCamera?

    override func didMove(to view: SKView) {
        setUpGameManager()
        setUpCamera()
    }

    override func update(_ currentTime: TimeInterval) {
        gameManager?.update(currentTime)
        gameCamera?.move()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }

        let touchPosition = touch.location(in: self)
        gameCamera?.lastTouchPosition = touchPosition
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }

        let touchPosition = touch.location(in: self)
        gameCamera?.setTargetPosition(using: touchPosition)
    }

    private func setUpCamera() {
        let camera = GameCamera(startingPosition: position)
        self.camera = camera
        gameCamera = camera
        addChild(camera)
    }

    private func setUpGameManager() {
        gameManager = GameManager(scene: self)
    }
}
