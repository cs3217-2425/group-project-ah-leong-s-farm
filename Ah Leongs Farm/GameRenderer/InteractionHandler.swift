//
//  InteractionHandler.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 30/3/25.
//

protocol InteractionHandler: AnyObject {
    func handleInteraction(node: IRenderNode)

    func handleInteraction(node: PlotSpriteNode)

    func handleInteraction(node: AppleSpriteNode)

    func handleInteraction(node: BokChoySpriteNode)

    func handleInteraction(node: PotatoSpriteNode)
}
