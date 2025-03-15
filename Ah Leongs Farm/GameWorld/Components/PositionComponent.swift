import GameplayKit

class PositionComponent: GKComponent {
    var x: CGFloat
    var y: CGFloat

    required init?(coder: NSCoder) {
        x = 0
        y = 0
        super.init(coder: coder)
    }

    init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
        super.init()
    }
}
