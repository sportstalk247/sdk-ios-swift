//
//  ClientConfig.swift
//  SportsTalk_iOS_SDK
//
//  Created by Angelo Lesano on 5/17/20.
//  Copyright © 2020 krishna41. All rights reserved.
//

import Foundation

public struct ClientConfig {
    var appId: String
    var authToken: String
    var endpoint: URL
    
    public init(appId: String, authToken: String, endpoint: URL?) {
        self.appId = appId
        self.authToken = authToken
        self.endpoint = endpoint ?? URL(string: "https://api.sportstalk247.com/api/v3")!
    }
}
