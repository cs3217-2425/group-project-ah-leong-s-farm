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

    init(view: SKView) {
        super.init(size: view.bounds.size)
        setupGestureRecognizers(in: view)
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
    }

    @objc private func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        guard gestureRecognizer.state == .began else {
            return
        }

        let touchPosition = gestureRecognizer.location(in: self.view)
        let scenePosition = convertPoint(fromView: touchPosition)

        if let (row, column) = uiPositionProvider?.getRowAndColumn(fromPosition: scenePosition) {
            interactionHandler?.handleGridInteraction(row: row, column: column)
        }
    }

    private func setupGestureRecognizers(in view: SKView) {
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        let rotationRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(handleRotationGesture(_:)))
        let longPressRecognizer = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleLongPress(_:))
        )

        pinchRecognizer.delegate = self
        panRecognizer.delegate = self
        rotationRecognizer.delegate = self

        /// this prevents the recognizer from cancelling basic touch events once a gesture is recognized
        /// In UIKit, this property is set to true by default
        pinchRecognizer.cancelsTouchesInView = false
        panRecognizer.cancelsTouchesInView = false
        rotationRecognizer.cancelsTouchesInView = false

        panRecognizer.maximumNumberOfTouches = 2

        view.addGestureRecognizer(pinchRecognizer)
        view.addGestureRecognizer(panRecognizer)
        view.addGestureRecognizer(rotationRecognizer)
        view.addGestureRecognizer(longPressRecognizer)
    }

    @objc private func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        gameCamera.scaleCamera(in: self, gesture: gesture)
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        gameCamera.panCamera(in: self, gesture: gesture)
    }

    @objc private func handleRotationGesture(_ gesture: UIRotationGestureRecognizer) {
        gameCamera.rotateCamera(in: self, gesture: gesture)
    }
}

extension GameScene: UIGestureRecognizerDelegate {
    /// allow multiple gesture recognizers to recognize gestures at the same time
    /// for this function to work, the protocol `UIGestureRecognizerDelegate` must be added to this class
    /// and a delegate must be set on the recognizer that needs to work with others
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }

    /// Use this function to determine if the gesture recognizer should handle the touch
    /// For example, return false if the touch is within a certain area that should only respond to direct touch events
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        true
    }
}
