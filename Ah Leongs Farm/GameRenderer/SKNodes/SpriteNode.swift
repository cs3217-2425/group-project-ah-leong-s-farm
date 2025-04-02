import SpriteKit

class SpriteNode: SKSpriteNode, IRenderNode {
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.isUserInteractionEnabled = true
    }

    func visitTouchHandlerRegistry(registry: any TouchHandlerRegistry) {
        // ignore
    }
}
