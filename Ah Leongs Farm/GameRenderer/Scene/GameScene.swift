import SpriteKit

class GameScene: SKScene {
    private let gameCamera = GameCamera()
    private weak var gameSceneUpdateDelegate: GameSceneUpdateDelegate?
    private weak var uiPositionProvider: UIPositionProvider?
    private weak var interactionHandler: GridInteractionHandler?

    override var camera: SKCameraNode? {
        get {
            gameCamera
        }
        set {
            // ignore
        }
    }

    override var isUserInteractionEnabled: Bool {
        get {
            true
        }
        set {
            // ignore
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(size: CGSize) {
        super.init(size: size)
    }

    func setGameSceneUpdateDelegate(_ delegate: GameSceneUpdateDelegate) {
        gameSceneUpdateDelegate = delegate
    }

    func setUIPositionProvider(_ provider: UIPositionProvider) {
        uiPositionProvider = provider
    }

    func setGridInteractionHandler(_ handler: GridInteractionHandler) {
        interactionHandler = handler
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

        if let (row, column) = uiPositionProvider?.getRowAndColumn(fromPosition: touchPosition) {
            interactionHandler?.handleGridInteraction(row: row, column: column)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }

        let touchPosition = touch.location(in: self)
        gameCamera.setTargetPosition(using: touchPosition)
    }
}
