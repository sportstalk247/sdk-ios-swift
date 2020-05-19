//
//  DeleteUserResponse.swift
//  SportsTalk_iOS_SDK
//
//  Created by Lawrence Cendana on 5/17/20.
//  Copyright © 2020 krishna41. All rights reserved.
//

import Foundation

public struct DeleteUserResponse: Codable {
    public var kind: String?
    public var user: User?
    
    private enum CodingKeys: String, CodingKey {
        case kind
        case user
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.kind = try container.decodeIfPresent(String.self, forKey: .kind)
        self.user = try container.decodeIfPresent(User.self, forKey: .user)
    }
}
