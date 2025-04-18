//
//  LoadSessionDelegate.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 15/4/25.
//

import Foundation

protocol LoadSessionDelegate: AnyObject {
    func loadSession(sessionId: UUID)
}
