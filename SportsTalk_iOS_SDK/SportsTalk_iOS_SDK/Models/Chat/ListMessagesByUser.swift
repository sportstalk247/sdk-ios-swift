//
//  ListMessagesByUser.swift
//  SportsTalk_iOS_SDK
//
//  Created by Lawrence Cendana on 5/17/20.
//  Copyright © 2020 krishna41. All rights reserved.
//

import Foundation

public struct ListMessagesByUser: Codable {
    public var kind: String?
    public var cursor: String?
    public var events: [Event]
    
    private enum CodingKeys: String, CodingKey {
        case kind
        case cursor
        case events
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.kind = try container.decodeIfPresent(String.self, forKey: .kind)
        self.cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
        self.events = try container.decodeIfPresent(Array<Event>.self, forKey: .events) ?? []
    }
}
