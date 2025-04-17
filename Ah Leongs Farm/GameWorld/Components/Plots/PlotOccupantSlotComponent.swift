//
//  PlotOccupantComponent.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 25/3/25.
//

import Foundation

class PlotOccupantSlotComponent: ComponentAdapter {
    var plotOccupant: PlotOccupant?

    init(plotOccupant: PlotOccupant? = nil) {
        guard let plotOccupant = plotOccupant else {
            self.plotOccupant = nil
            super.init()
            return
        }

        self.plotOccupant = plotOccupant
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}
