//
//  UserList.swift
//  SportsTalk_iOS_SDK
//
//  Created by Lawrence Cendana on 5/17/20.
//  Copyright © 2020 krishna41. All rights reserved.
//

import Foundation

public struct UserList: Codable {
    public var kind: String?
    public var cursor: String?
    public var users: [User]
    
    private enum CodingKeys: String, CodingKey {
        case kind
        case cursor
        case users
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.kind = try container.decodeIfPresent(String.self, forKey: .kind)
        self.cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
        self.users = try container.decodeIfPresent(Array<User>.self, forKey: .users) ?? []
    }
}
