import SpriteKit

class PlotSpriteNode: SKSpriteNode {
    weak var interactionDelegate: PlotInteractionHandler?

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.isUserInteractionEnabled = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        interactionDelegate?.showPlotActions(for: self)
    }
}
