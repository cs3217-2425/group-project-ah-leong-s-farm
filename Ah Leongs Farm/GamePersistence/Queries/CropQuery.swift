//
//  CropQuery.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 18/4/25.
//

import Foundation

protocol CropQuery {
    func fetch(sessionId: UUID) -> [any Crop]
}
