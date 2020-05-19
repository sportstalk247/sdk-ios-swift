//
//  ListMessagesNeedingModerationResponse.swift
//  SportsTalk_iOS_SDK
//
//  Created by Lawrence Cendana on 5/17/20.
//  Copyright © 2020 krishna41. All rights reserved.
//

import Foundation

public struct ListMessagesNeedingModerationResponse: Codable {
    public var kind: String?
    public var events: [Event]
    
    private enum CodingKeys: String, CodingKey {
        case kind
        case events
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.kind = try container.decodeIfPresent(String.self, forKey: .kind)
        self.events = try container.decodeIfPresent(Array<Event>.self, forKey: .events) ?? []
    }
}
