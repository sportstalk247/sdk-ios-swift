import Foundation

public struct ListNotificationResponse: Codable {
    public var kind: String?
    public var cursor: String?
    public var more: Bool?
    public var itemcount: Int?
    public var notifications: [UserNotification]?
}
