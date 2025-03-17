//
//  Grid.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 14/3/25.
//

import GameplayKit

class FarmLand: GKEntity {
    private static let TileSetName: String = "Farm Tile Set"
    private static let LandTileGroupName: String = "Land"
    private static let TileSize: CGSize = CGSize(width: 48, height: 48)

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(rows: Int, columns: Int) {
        super.init()
        setUpComponents(rows: rows, columns: columns)
    }

    private func setUpComponents(rows: Int, columns: Int) {
        guard let tileSet = SKTileSet(named: FarmLand.TileSetName) else {
            return
        }

        let tileMapComponent = TileMapComponent(
            tileSet: tileSet,
            rows: rows,
            columns: columns,
            tileSize: FarmLand.TileSize
        )
        tileMapComponent.fill(with: FarmLand.LandTileGroupName)

        addComponent(tileMapComponent)
        addComponent(GridComponent(rows: rows, columns: columns))
    }
}
