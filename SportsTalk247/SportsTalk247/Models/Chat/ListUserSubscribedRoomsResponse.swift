//
//  ListUserSubscribedRoomsResponse.swift
//  SportsTalk247
//
//  Created by Lawrence Cendana on 12/14/22.
//  Copyright © 2022 krishna41. All rights reserved.
//

import Foundation

public struct ListUserSubscribedRoomsResponse: Codable {
    public var kind: String?    // "list.userroomsubscriptions"
    public var cursor: String?
    public var more: Bool?
    public var itemcount: Int64?
    public var subscriptions: [SubscriptionAndRoomStatus] = []
    
    private enum CodingKeys: String, CodingKey {
        case kind
        case cursor
        case more
        case itemcount
        case subscriptions
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.kind = try container.decodeIfPresent(String.self, forKey: .kind)
        self.cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
        self.more = try container.decodeIfPresent(Bool.self, forKey: .more)
        self.itemcount = try container.decodeIfPresent(Int64.self, forKey: .itemcount)
        if container.contains(.subscriptions) {
            self.subscriptions = try container.decode(Array<SubscriptionAndRoomStatus>.self, forKey: .subscriptions)
        } else {
            self.subscriptions = []
        }
    }
    
}

public struct SubscriptionAndRoomStatus: Codable {
    public var kind: String?     // "chat.subscriptionandstatus"
    public var subscription: ChatSubscription?
    public var roomstatus: RoomStatus?
    
    private enum CodingKeys: String, CodingKey {
        case kind
        case subscription
        case roomstatus
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.kind = try container.decodeIfPresent(String.self, forKey: .kind)
        self.subscription = try container.decodeIfPresent(ChatSubscription.self, forKey: .subscription)
        self.roomstatus = try container.decodeIfPresent(RoomStatus.self, forKey: .roomstatus)
    }
}

public struct RoomStatus: Codable {
    public var kind: String?     // "chat.roomstatus"
    public var messagecount: Int64?
    public var participantcount: Int64?
    public var newestmessage : Event?
    
    private enum CodingKeys: String, CodingKey {
        case kind
        case messagecount
        case participantcount
        case newestmessage
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RoomStatus.CodingKeys.self)
        self.kind = try container.decodeIfPresent(String.self, forKey: .kind)
        self.messagecount = try container.decodeIfPresent(Int64.self, forKey: .messagecount)
        self.participantcount = try container.decodeIfPresent(Int64.self, forKey: .participantcount)
        self.newestmessage = try container.decodeIfPresent(Event.self, forKey: .newestmessage)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(kind, forKey: .kind)
        try container.encodeIfPresent(messagecount, forKey: .messagecount)
        try container.encodeIfPresent(participantcount, forKey: .participantcount)
        try container.encodeIfPresent(newestmessage, forKey: .newestmessage)
    }
}

