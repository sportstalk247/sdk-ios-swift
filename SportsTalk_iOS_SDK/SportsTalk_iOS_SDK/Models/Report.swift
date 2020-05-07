import Foundation

public struct Report{
    public let userid: String
    public let reason: String
    
    public static func from(dict: [String:Any]) -> Report{
        let userid = dict["userid"] as? String ?? ""
        let reason = dict["reason"] as? String ?? ""
        return Report(userid: userid, reason: reason)
    }
}
