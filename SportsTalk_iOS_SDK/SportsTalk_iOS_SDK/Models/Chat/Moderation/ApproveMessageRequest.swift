//
//  ApproveMessageRequest.swift
//  SportsTalk_iOS_SDK
//
//  Created by Lawrence Cendana on 5/17/20.
//  Copyright © 2020 krishna41. All rights reserved.
//

import Foundation

struct ApproveMessageRequest: Codable {
    public var approve: Bool
    
    private enum CodingKeys: String, CodingKey {
        case approve
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.approve = try container.decode(Bool.self, forKey: .approve)
    }
}
