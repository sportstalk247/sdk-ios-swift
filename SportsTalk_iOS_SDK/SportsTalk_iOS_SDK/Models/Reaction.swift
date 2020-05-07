import Foundation

public class Reaction: NSObject
{
    public var users: [User]?
    public var type: String?
    public var count: Int?
    
    public static func convertIntoModel(response:[String:Any]) -> Reaction
    {
        let ret = Reaction()
        
        if let users = response["users"] as? [[String: Any]]
        {
            ret.users = [User]()
            
            for user in users
            {
                ret.users?.append(User().convertIntoModel(response: user))
            }
        }
        
        if let type = response["type"] as? String
        {
            ret.type = type
        }
        
        if let count = response["count"] as? Int
        {
            ret.count = count
        }
        
        return ret
    }
}

