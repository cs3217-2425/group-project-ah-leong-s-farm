import SpriteKit

class GameScene: SKScene {
    private let gameCamera = GameCamera()
    private weak var gameSceneUpdateDelegate: GameSceneUpdateDelegate?

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(size: CGSize) {
        super.init(size: size)

        // attach gameCamera to self
        camera = gameCamera
        addChild(gameCamera)
    }

    func setGameSceneUpdateDelegate(_ delegate: GameSceneUpdateDelegate) {
        gameSceneUpdateDelegate = delegate
    }

    override func didMove(to view: SKView) {
        gameCamera.position = position
    }

    override func update(_ currentTime: TimeInterval) {
        gameSceneUpdateDelegate?.update(currentTime)
        gameCamera.move()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }

        let touchPosition = touch.location(in: self)
        gameCamera.lastTouchPosition = touchPosition
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }

        let touchPosition = touch.location(in: self)
        gameCamera.setTargetPosition(using: touchPosition)
    }
}
