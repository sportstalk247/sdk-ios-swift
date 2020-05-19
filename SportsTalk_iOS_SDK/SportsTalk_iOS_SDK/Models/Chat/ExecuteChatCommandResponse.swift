//
//  ExecuteChatCommandResponse.swift
//  SportsTalk_iOS_SDK
//
//  Created by Lawrence Cendana on 5/17/20.
//  Copyright © 2020 krishna41. All rights reserved.
//

import Foundation

public struct ExecuteChatCommandResponse: Codable {
    public var kind: String?
    public var op: String?
    public var room: ChatRoom?
    public var speech: Event?
    public var action: Event?
    
    private enum CodingKeys: String, CodingKey {
        case kind
        case op
        case room
        case speech
        case action
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.kind = try container.decodeIfPresent(String.self, forKey: .kind)
        self.op = try container.decodeIfPresent(String.self, forKey: .op)
        self.room = try container.decodeIfPresent(ChatRoom.self, forKey: .room)
        self.speech = try container.decodeIfPresent(Event.self, forKey: .speech)
        self.action = try container.decodeIfPresent(Event.self, forKey: .action)
    }
    
}
