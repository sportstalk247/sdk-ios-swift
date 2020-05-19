//
//  ChatEvent.swift
//  SportsTalk_iOS_SDK
//
//  Created by Lawrence Cendana on 5/17/20.
//  Copyright © 2020 krishna41. All rights reserved.
//

import Foundation

public class Event: Codable {
    public var kind: String?
    public var id: String?
    public var roomid: String?
    public var body: String?
    var addedString: String?
    public var added: Date?
    var tsString: String?
    public var ts: Date?
    public var eventtype: String? // EventType
    public var userid: String?
    public var user: User?
    public var customtype: String?
    public var customid: String?
    public var custompayload: String?
    public var customtags: [String]?
    public var customfield1: String?
    public var customfield2: String?
    public var replyto: Event?
    public var parentid: String?
    public var edited: Bool?
    public var deleted: Bool?
    public var active: Bool?
    public var shadowban: Bool?
    public var likecount: Int64?
    public var replycount: Int64?
    public var reactions: [ChatEventReaction]
    public var moderation: String?
    public var reports: [ChatEventReport]
    
    private enum CodingKeys: String, CodingKey {
        case kind
        case id
        case roomid
        case body
        case addedString
        case tsString
        case eventtype
        case userid
        case user
        case customtype
        case customid
        case custompayload
        case customtags
        case replyto
        case parentid
        case edited
        case deleted
        case active
        case shadowban
        case likecount
        case replycount
        case reactions
        case moderation
        case reports
    }
    
    init() {
        self.kind = nil
        self.id = nil
        self.roomid = nil
        self.body = nil
        self.addedString = nil
        self.tsString = nil
        self.eventtype = nil
        self.userid = nil
        self.user = nil
        self.customtype = nil
        self.customid = nil
        self.custompayload = nil
        self.customtags = []
        self.replyto = nil
        self.parentid = nil
        self.edited = nil
        self.deleted = nil
        self.active = nil
        self.shadowban = nil
        self.likecount = nil
        self.replycount = nil
        self.reactions = []
        self.moderation = nil
        self.reports = []
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.kind = try container.decodeIfPresent(String.self, forKey: .kind)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.roomid = try container.decodeIfPresent(String.self, forKey: .roomid)
        self.body = try container.decodeIfPresent(String.self, forKey: .body)
        if let added = try container.decodeIfPresent(String.self, forKey: .addedString) {
            self.added = ISODateFormat(added)
        }
        if let ts = try container.decodeIfPresent(String.self, forKey: .tsString) {
            self.ts = ISODateFormat(ts)
        }
        self.eventtype = try container.decodeIfPresent(String.self, forKey: .eventtype)
        self.userid = try container.decodeIfPresent(String.self, forKey: .userid)
        self.user = try container.decodeIfPresent(User.self, forKey: .user)
        self.customtype = try container.decodeIfPresent(String.self, forKey: .customtype)
        self.customid = try container.decodeIfPresent(String.self, forKey: .customid)
        self.custompayload = try container.decodeIfPresent(String.self, forKey: .custompayload)
        self.customtags = try container.decodeIfPresent([String].self, forKey: .customtags)
        self.replyto = try container.decodeIfPresent(Event.self, forKey: .replyto)
        self.parentid = try container.decodeIfPresent(String.self, forKey: .parentid)
        self.edited = try container.decodeIfPresent(Bool.self, forKey: .edited)
        self.deleted = try container.decodeIfPresent(Bool.self, forKey: .deleted)
        self.active = try container.decodeIfPresent(Bool.self, forKey: .active)
        self.shadowban = try container.decodeIfPresent(Bool.self, forKey: .shadowban)
        self.likecount = try container.decodeIfPresent(Int64.self, forKey: .likecount)
        self.replycount = try container.decodeIfPresent(Int64.self, forKey: .replycount)
        self.reactions = try container.decodeIfPresent(Array<ChatEventReaction>.self, forKey: .reactions) ?? []
        self.moderation = try container.decodeIfPresent(String.self, forKey: .moderation)
        self.reports = try container.decodeIfPresent(Array<ChatEventReport>.self, forKey: .reports) ?? []
    }
}

public struct ChatEventReaction: Codable {
    var type: String?
    var count: Int64?
    var users: [User]
    
    private enum CodingKeys: String, CodingKey {
        case type
        case count
        case users
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.count = try container.decodeIfPresent(Int64.self, forKey: .count)
        self.users = try container.decodeIfPresent(Array<User>.self, forKey: .users) ?? []
    }
}

public struct ChatEventReport: Codable {
    var userid: String?
    var reason: String?
    
    private enum CodingKeys: String, CodingKey {
        case userid
        case reason
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userid = try container.decodeIfPresent(String.self, forKey: .userid)
        self.reason = try container.decodeIfPresent(String.self, forKey: .reason)
    }
}

public struct EventType {
    static let SPEECH = "speech"
    static let PURGE = "purge"
    static let REACTION = "reaction"
    static let ROOM_CLOSED = "roomClosed"
    static let ROOM_OPEN = "roomopen"
    static let ACTION = "action"
    static let REPLY = "reply"
    static let GOAL = "goal"
    static let ADVERTISMENT = "advertisement"
}

internal func ISODateFormat(_ string: String) -> Date? {
    let formatter = ISO8601DateFormatter()
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.formatOptions = [.withFullDate,
                               .withFullTime,
                               .withDashSeparatorInDate,
                               .withFractionalSeconds]
            
    return formatter.date(from: string)
}
