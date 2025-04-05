import SpriteKit

/// A class to represent the camera in a game scene.
/// Able to pan, zoom, and scale.
/// Adapted from: https://gist.github.com/AchrafKassioui/bd835b99a78e9ce29b08ce406896c59b
class GameCamera: SKCameraNode {
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init() {
        super.init()
    }

    // MARK: - Camera zoom

    /// zoom settings
    private var cameraMaxScale: CGFloat = 100
    private var cameraMinScale: CGFloat = 0.01
    private var cameraScaleInertia: CGFloat = 0.75

    /// zoom state
    private var cameraScaleVelocity: CGFloat = 0
    private var cameraScaleBeforePinch: CGFloat = 1
    private var cameraPositionBeforePinch = CGPoint.zero

    func scaleCamera(in scene: SKScene, gesture: UIPinchGestureRecognizer) {
        guard let view = scene.view else {
            return
        }

        let scaleCenterInView = gesture.location(in: view)
        let scaleCenterInScene = scene.convertPoint(fromView: scaleCenterInView)

        if gesture.state == .began {
            cameraScaleBeforePinch = xScale
            cameraPositionBeforePinch = position
            return
        }

        if gesture.state == .changed {

            /// calculate the new scale, and clamp within the range
            let newScale = xScale / gesture.scale
            let clampedScale = max(min(newScale, cameraMaxScale), cameraMinScale)

            /// calculate a factor to move the camera toward the pinch midpoint
            let translationFactor = clampedScale / xScale
            let newCamPosX = scaleCenterInScene.x + (position.x - scaleCenterInScene.x) * translationFactor
            let newCamPosY = scaleCenterInScene.y + (position.y - scaleCenterInScene.y) * translationFactor

            /// update camera's scale and position
            /// setScale must be called now and no earlier
            setScale(clampedScale)
            position = CGPoint(x: newCamPosX, y: newCamPosY)

            gesture.scale = 1.0

            return
        }

        if gesture.state == .ended {
            cameraScaleVelocity = xScale * gesture.velocity / 100
            return

        }

        if gesture.state == .cancelled {
            setScale(cameraScaleBeforePinch)
            position = cameraPositionBeforePinch
            return
        }
    }

    // MARK: - Camera pan

    /// pan settings
    private var cameraPositionInertia: CGFloat = 0.95

    /// pan state
    private var cameraPositionVelocity: (x: CGFloat, y: CGFloat) = (0, 0)
    private var cameraPositionBeforePan = CGPoint.zero

    func panCamera(in scene: SKScene, gesture: UIPanGestureRecognizer) {
        let view = scene.view

        if gesture.state == .changed {

            /// convert UIKit translation coordinates into SpriteKit's coordinate system
            /// for mathematical clarity further down
            let uiKitTranslation = gesture.translation(in: view)
            let translation = CGPoint(
                /// UIKit and SpriteKit share the same x-axis direction
                x: uiKitTranslation.x,
                /// invert y because UIKit's y-axis increases downwards, opposite to SpriteKit's
                y: -uiKitTranslation.y
            )

            /// transform the translation from the screen coordinate system to the
            /// camera's local coordinate system, considering its rotation.
            let angle = zRotation
            let dx = translation.x * cos(angle) - translation.y * sin(angle)
            let dy = translation.x * sin(angle) + translation.y * cos(angle)

            /// calculate the translation
            /// apply it to the current camera position
            position = CGPoint(
                x: position.x - dx * xScale,
                y: position.y - dy * yScale
            )

            /// reset the translation
            gesture.setTranslation(.zero, in: view)

            return
        }

        if gesture.state == .ended {
            /// at the end of the gesture, calculate the velocity to apply inertia.
            /// We devide by an arbitrary factor for better user experience
            cameraPositionVelocity.x = xScale * gesture.velocity(in: view).x / 100
            cameraPositionVelocity.y = yScale * gesture.velocity(in: view).y / 100
            return

        }

        if gesture.state == .cancelled {

            /// if the gesture is cancelled, revert to the camera's position at the beginning of the gesture
            position = cameraPositionBeforePan

            return
        }
    }

    // MARK: - Camera rotation

    /// rotation settings
    private var cameraRotationInertia: CGFloat = 0.85

    /// rotation state
    private var cameraRotationVelocity: CGFloat = 0
    private var cameraRotationWhenGestureStarts: CGFloat = 0
    private var cumulativeRotation: CGFloat = 0
    private var rotationPivot = CGPoint.zero

    func rotateCamera(in scene: SKScene, gesture: UIRotationGestureRecognizer) {
        guard let view = scene.view else {
            return
        }

        let midpointInView = gesture.location(in: view)
        let midpointInScene = scene.convertPoint(fromView: midpointInView)

        if gesture.state == .began {
            cameraRotationWhenGestureStarts = zRotation
            rotationPivot = midpointInScene
            cumulativeRotation = 0
            return
        }

        if gesture.state == .changed {

            /// update camera rotation
            zRotation = gesture.rotation + cameraRotationWhenGestureStarts

            /// store the rotation change since the last change
            /// needed to update the camera position live
            let rotationDelta = gesture.rotation - cumulativeRotation
            cumulativeRotation += rotationDelta

            /// Calculate how the camera should be moved
            let offsetX = position.x - rotationPivot.x
            let offsetY = position.y - rotationPivot.y

            let rotatedOffsetX = cos(rotationDelta) * offsetX - sin(rotationDelta) * offsetY
            let rotatedOffsetY = sin(rotationDelta) * offsetX + cos(rotationDelta) * offsetY

            let newCameraPositionX = rotationPivot.x + rotatedOffsetX
            let newCameraPositionY = rotationPivot.y + rotatedOffsetY

            position = CGPoint(x: newCameraPositionX, y: newCameraPositionY)

            return
        }

        if gesture.state == .ended {
            cameraRotationVelocity = xScale * gesture.velocity / 100
            return
        }

        if gesture.state == .cancelled {
            zRotation = cameraRotationWhenGestureStarts
            return
        }
    }
}
