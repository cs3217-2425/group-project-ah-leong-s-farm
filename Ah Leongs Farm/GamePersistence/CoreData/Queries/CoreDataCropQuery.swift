//
//  CoreDataCropQuery.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 18/4/25.
//

import CoreData
import UIKit

class CoreDataCropQuery: CropQuery {
    private let store: Store

    init(store: Store) {
        self.store = store
    }

    convenience init?() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }

        self.init(store: appDelegate.persistentContainer)
    }

    func fetch(sessionId: UUID) -> [any Crop] {
        guard let session = fetchSession(sessionId: sessionId) else {
            return []
        }

        let crops = session.crops ?? []

        return crops.compactMap({ $0 as? CropDeserializable })
            .map({ $0.deserialize() })
    }

    private func fetchSession(sessionId: UUID) -> Session? {
        let request = Session.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", sessionId as CVarArg)

        return store.fetch(request: request).first
    }
}
