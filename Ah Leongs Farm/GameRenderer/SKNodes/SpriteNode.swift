import SpriteKit

class SpriteNode: SKSpriteNode, IRenderNode {
    weak var handler: InteractionHandler?

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.isUserInteractionEnabled = true
    }
}

final class PlotSpriteNode: SpriteNode {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handler?.handleInteraction(node: self)
    }
}
