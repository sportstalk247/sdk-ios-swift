import Foundation

public class Room
{
    public var kind: String?
    public var id: String?
    public var appid: String?
    public var ownerid: String?
    public var name: String?
    public var description: String?
    public var iframeUrl: String?
    public var slug: String?
    public var enableActions: Bool?
    public var enableEnterAndExit: Bool?
    public var open: Bool?
    public var inroom: Int?
    public var whenmodified: String?
    public var moderation: String?
    public var maxreports: Int?
    
    func convertIntoModel(response:[String:Any]) -> Room
    {
        if let kind = response["kind"] as? String
        {
            self.kind = kind
        }
        
        if let id = response["id"] as? String
        {
            self.id = id
        }
        
        if let appid = response["appid"] as? String
        {
            self.appid = appid
        }
        
        if let ownerid = response["ownerid"] as? String
        {
            self.ownerid = ownerid
        }
        
        if let name = response["name"] as? String
        {
            self.name = name
        }
        
        if let description = response["description"] as? String
        {
            self.description = description
        }
        
        if let iframeUrl = response["iframeUrl"] as? String
        {
            self.iframeUrl = iframeUrl
        }
        
        if let slug = response["slug"] as? String
        {
            self.slug = slug
        }

        if let enableActions = response["enableActions"] as? Int
        {
            self.enableActions = NSNumber(value: enableActions).boolValue
        }
        
        if let enableEnterAndExit = response["enableEnterAndExit"] as? Int
        {
            self.enableEnterAndExit = NSNumber(value: enableEnterAndExit).boolValue
        }
        
        if let open = response["open"] as? Int
        {
            self.open = NSNumber(value: open).boolValue
        }
        
        if let inroom = response["inroom"] as? Int
        {
            self.inroom = inroom
        }
        
        if let whenmodified = response["whenmodified"] as? String
        {
            self.whenmodified = whenmodified
        }
        
         if let maxreports = response["maxreports"] as? Int
         {
             self.maxreports = maxreports
         }
                 
        return self
    }
}
