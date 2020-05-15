import Foundation

public struct CommentConversation{
    public let title: String
    public let conversationid: String
    public let owneruserid: String
    public let open: Bool
    public let property: String
    public let customid: String
    public let commentcount: Int
    public let whenmodified: Int
    
    
    public static func from(dict: [String:Any]) -> CommentConversation{
        let title = dict["title"] as? String ?? ""
        let conversationid = dict["conversationid"] as? String ?? ""
        let owneruserid = dict["owneruserid"] as? String ?? ""
        let open = dict["open"] as? Bool ?? false
        let property = dict["property"] as? String ?? ""
        let customid = dict["customid"] as? String ?? ""
        let commentcount =  dict["commentcount"] as? Int ?? 0
        let whenmodified = dict["whenmodified"] as? Int ?? 0
        
        return CommentConversation(title: title, conversationid: conversationid, owneruserid: owneruserid, open: open, property: property, customid: customid, commentcount: commentcount, whenmodified: whenmodified)
    }
}
