import Foundation

public class Message: NSObject
{
    public var kind: String?
    public var id: String?
    public var roomId: String?
    public var body: String?
    public var added: Int?
    public var eventtype: String?
    public var userid: String?
    public var customtype: String?
    public var customid: String?
    public var custompayload: String?
    public var replyto: Message?
    public var reactions: [Reaction]?
    public var moderation: String?
    public var active: String?
    public var reports: [String]?
    public var user: User?

    public func convertIntoModel(response:[String:Any]) -> Message
    {
        if let kind = response["kind"] as? String
        {
            self.kind = kind
        }
        
        if let id = response["id"] as? String
        {
            self.id = id
        }
        
        if let roomId = response["roomId"] as? String
        {
            self.roomId = roomId
        }
        
        if let body = response["body"] as? String
        {
            self.body = body
        }
        
        if let added = response["added"] as? Int
        {
            self.added = added
        }
        
        if let eventtype = response["eventtype"] as? String
        {
            self.eventtype = eventtype
        }
        
        if let userid = response["userid"] as? String
        {
            self.userid = userid
        }
        
        if let customtype = response["customtype"] as? String
        {
            self.customtype = customtype
        }

        if let customid = response["customid"] as? String
        {
            self.customid = customid
        }
        
        if let custompayload = response["custompayload"] as? String
        {
            self.custompayload = custompayload
        }
        
        if let replyto = response["replyto"] as? [String: Any]
        {
            self.replyto = Message().convertIntoModel(response: replyto)
        }
        
        if let reactions = response["reactions"] as? [[String: Any]]
        {
            self.reactions = [Reaction]()
            
            for reaction in reactions
            {
                self.reactions?.append(Reaction.convertIntoModel(response: reaction))
            }
        }
        
        if let moderation = response["moderation"] as? String
        {
            self.moderation = moderation
        }
        
         if let active = response["active"] as? String
         {
             self.active = active
         }
         
         if let reports = response["reports"] as? [String]
         {
             self.reports = reports
         }
         
         if let user = response["user"] as? [String: Any]
         {
             self.user = User().convertIntoModel(response: user)
         }
        
        return self
    }
}

