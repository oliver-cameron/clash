//
//  message.swift
//  clash
//
//  Created by Oliver Cameron on 20/4/2025.
//

import Foundation
class message{
    var recipient: [user]
    var sender: user
    var type: messageType
    var data: String?
    init(recipient: [user], sender: user, type: messageType, data: String? = nil) {
        self.recipient = recipient
        self.sender = sender
        self.type = type
        self.data = data
    }
}
enum messageType: String, Codable {
    case reciept
    case text
    case status
}
