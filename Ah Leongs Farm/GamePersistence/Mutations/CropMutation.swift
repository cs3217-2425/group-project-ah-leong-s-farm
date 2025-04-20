//
//  CropMutation.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 18/4/25.
//

import Foundation

protocol CropMutation<T> {
    associatedtype T: Crop

    func upsertCrop(sessionId: UUID, id: UUID, crop: T) -> Bool

    func deleteCrop(id: UUID) -> Bool
}
