//
//  GetRoomExtendedDetailsResponse.swift
//  SportsTalk247
//
//  Created by Angelo Lesano on 6/8/21.
//  Copyright © 2021 krishna41. All rights reserved.
//

import Foundation

public struct GetRoomExtendedDetailsResponse: Codable {
    public var kind: String?
    public var details: [ChatRoom]?
    
    private enum CodingKeys: String, CodingKey {
        case kind
        case details
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.kind = try container.decodeIfPresent(String.self, forKey: .kind)
        self.details = try container.decodeIfPresent([ChatRoom].self, forKey: .details)
    }
}
