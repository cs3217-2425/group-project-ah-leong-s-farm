//
//  SessionViewCellDelegate.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 16/4/25.
//

import Foundation

protocol SessionViewCellDelegate: AnyObject {
    func didTapDelete(sessionId: UUID)
}
