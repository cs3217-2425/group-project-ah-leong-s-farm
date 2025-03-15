import SpriteKit

class GameCamera: SKCameraNode {
    private static let SmoothingFactor: Double = 0.1

    var lastTouchPosition: CGPoint?

    private var targetPosition: CGPoint = .zero

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(startingPosition: CGPoint) {
        targetPosition = startingPosition
        super.init()
        position = startingPosition
    }

    func setTargetPosition(using touchPosition: CGPoint) {
        guard let lastTouchPosition = lastTouchPosition else {
            self.lastTouchPosition = touchPosition
            return
        }

        let delta = CGPoint(x: touchPosition.x - lastTouchPosition.x, y: touchPosition.y - lastTouchPosition.y)

        // Update the target position instead of directly updating the camera's position
        targetPosition.x -= delta.x
        targetPosition.y -= delta.y

        self.lastTouchPosition = touchPosition
    }

    /// Interpolate the camera's position towards the target position
    func move() {
        position.x += (targetPosition.x - position.x) * GameCamera.SmoothingFactor
        position.y += (targetPosition.y - position.y) * GameCamera.SmoothingFactor
    }
}
