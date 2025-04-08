import Foundation

class PositionComponent: ComponentAdapter {
    var x: CGFloat
    var y: CGFloat

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
        super.init()
    }
}

extension PositionComponent {
    func toCGPoint() -> CGPoint {
        CGPoint(x: x, y: y)
    }
}
