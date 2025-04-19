//
//  CoreDataSolarPanelMutation.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 19/4/25.
//

import Foundation
import UIKit

class CoreDataSolarPanelMutation: SolarPanelMutation{
    private let store: Store
    private let serializer: SolarPanelSerializer

    init(store: Store) {
        self.store = store
        serializer = SolarPanelSerializer(store: store)
    }

    convenience init?() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }

        self.init(store: appDelegate.persistentContainer)
    }

    func upsertSolarPanel(sessionId: UUID, id: UUID, solarPanel: SolarPanel) -> Bool {
        guard serializer.serialize(id: id, solarPanel: solarPanel)
            ?? serializer.serializeNew(sessionId: sessionId, id: id, solarPanel: solarPanel) != nil else {
            return false
        }

        do {
            try store.save()
        } catch {
            store.rollback()
            return false
        }

        return true
    }

    func deleteSolarPanel(id: UUID, solarPanel: SolarPanel) -> Bool {
        guard let persistenceEntity = fetchSolarPanelById(id: id) else {
            return false
        }

        store.managedContext.delete(persistenceEntity)

        do {
            try store.save()
        } catch {
            store.rollback()
            return false
        }

        return true
    }

    private func fetchSolarPanelById(id: UUID) -> SolarPanelPersistenceEntity? {
        let fetchRequest = SolarPanelPersistenceEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        let result = store.fetch(request: fetchRequest)
        return result.first
    }
}
