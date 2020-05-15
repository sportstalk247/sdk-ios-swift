import Foundation

public class User: NSObject
{
    public var userid: String?
    public var handle: String?
    public var profileurl: String?
    public var banned: Int?
    public var displayname: String?
    public var handlelowercase: String?
    public var pictureurl: String?
    public var kind: String?
    
    public func convertIntoModel(response:[String:Any]) -> User
    {
        if let userid = response["userid"] as? String
        {
            self.userid = userid
        }
        
        if let handle = response["handle"] as? String
        {
            self.handle = handle
        }
        
        if let profileurl = response["profileurl"] as? String
        {
            self.profileurl = profileurl
        }
        
        if let banned = response["banned"] as? Int
        {
            self.banned = banned
        }
        
        if let displayname = response["displayname"] as? String
        {
            self.displayname = displayname
        }
        
        if let handlelowercase = response["handlelowercase"] as? String
        {
            self.handlelowercase = handlelowercase
        }
        
        if let pictureurl = response["pictureurl"] as? String
        {
            self.pictureurl = pictureurl
        }
        
        if let kind = response["kind"] as? String
        {
            self.kind = kind
        }

        return self
    }
    
    public func getUrlString() -> String{
       return pictureurl ?? ""
    }
}

