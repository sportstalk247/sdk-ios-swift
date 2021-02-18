import Foundation

public class JoinChatRoomResponse: NSObject, Codable {
    public var kind: String?
    public var user: User?
    public var room: ChatRoom?
    public var eventscursor: GetUpdatesResponse?
    
    private enum CodingKeys: String, CodingKey {
        case kind
        case user
        case room
        case eventscursor
    }
    
    required public convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.kind = try container.decodeIfPresent(String.self, forKey: .kind)
        self.user = try container.decodeIfPresent(User.self, forKey: .user)
        self.room = try container.decodeIfPresent(ChatRoom.self, forKey: .room)
        self.eventscursor = try container.decodeIfPresent(GetUpdatesResponse.self, forKey: .eventscursor)
    }
    
}
