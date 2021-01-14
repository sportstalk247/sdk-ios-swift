import Foundation

open class UserNotification: Codable {
    public var kind: String?
    public var id: String?
    public var added: Date?
    public var userid: String?
    public var ts: Date?
    public var whenread: String?
    public var isread: Bool?
    public var notificationtype: String?
    
    private enum CodingKeys: String, CodingKey {
        case kind
        case id
        case added
        case userid
        case ts
        case whenread
        case isread
        case notificationtype
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.kind = try container.decodeIfPresent(String.self, forKey: .kind)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.userid = try container.decodeIfPresent(String.self, forKey: .userid)
        self.whenread = try container.decodeIfPresent(String.self, forKey: .whenread)
        self.isread = try container.decodeIfPresent(Bool.self, forKey: .isread)
        self.notificationtype = try container.decodeIfPresent(String.self, forKey: .notificationtype)
        
        if let added = try container.decodeIfPresent(String.self, forKey: .added) {
            self.added = ISODateFormat(added)
        }
        
        if let ts = try container.decodeIfPresent(Double.self, forKey: .ts) {
            self.ts = Date(timeIntervalSince1970: ts)
        }
    }
}
