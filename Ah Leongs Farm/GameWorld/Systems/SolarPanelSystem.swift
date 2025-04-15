//
//  SolarPanelSystem.swift
//  Ah Leongs Farm
//
//  Created by proglab on 16/4/25.
//

import Foundation

class SolarPanelSystem: ISystem {
    var manager: EntityManager?

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    private var grid: GridComponent? {
        manager?.getSingletonComponent(ofType: GridComponent.self)
    }

    @discardableResult
    func placeSolarPanel(solarPanel: SolarPanel, row: Int, column: Int) -> Bool {
        guard let plotEntity = grid?.getEntity(row: row, column: column) else {
            return false
        }

        guard let plotOccupantSlot = plotEntity.getComponentByType(ofType: PlotOccupantSlotComponent.self) else {
            return false
        }

        manager?.addComponent(PositionComponent(x: CGFloat(row), y: CGFloat(column)), to: solarPanel)
        manager?.addComponent(SpriteComponent(visitor: solarPanel), to: solarPanel)
        plotOccupantSlot.plotOccupant = solarPanel
        return true
    }

    func removeSolarPanel(row: Int, column: Int) -> Bool {
        guard let manager = manager else {
            return false
        }

        guard let plotEntity = grid?.getEntity(row: row, column: column) else {
            return false
        }

        guard let plotOccupantSlot = plotEntity.getComponentByType(ofType: PlotOccupantSlotComponent.self),
              let solarPanel = plotOccupantSlot.plotOccupant as? SolarPanel else {
            return false
        }

        manager.removeEntity(solarPanel)
        plotOccupantSlot.plotOccupant = nil

        return true
    }
}
