//
//  SDKError.swift
//  SportsTalk247
//
//  Created by Angelo Lesano on 2/17/21.
//  Copyright © 2021 krishna41. All rights reserved.
//

import Foundation

public enum SDKError: Swift.Error {
    case RequestSpam
    case InvalidParameters
    case Unknown
}

extension SDKError {}

extension SDKError {
    var localizedDescription: String {
        switch self {
        case .RequestSpam:
            return "SDK Error: Command is being sent too frequently. Please wait 3000ms until you send another"
        case .InvalidParameters:
            return "SDK Error: Some required parameters are missing."
        case .Unknown:
            return "An unknown error has occurred."
        }
    }
}
