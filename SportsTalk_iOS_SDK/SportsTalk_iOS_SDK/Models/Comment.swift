import Foundation

public struct Comment{
    public let id: String
    public let conversationid: String
    public let body: String
    public let user: User?
    public let parentid: String?
    public let reactions: [Reaction]?
    public let replycount: Int
    public let votecount: Int
    public let votescore: Int
    public let reports: [Report]?
    public let added: Int
    public let modified: Int
    
    public static func from(dict: [String:Any]) -> Comment{
        
        let id: String = dict["id"] as? String ?? ""
        let conversationid: String = dict["conversationid"] as? String ?? ""
        let body: String = dict["body"] as? String ?? ""
        
        let user: User?
        if let userDict = dict["user"] as? [String:Any]{
            user = User().convertIntoModel(response: userDict)
        }else{
            user = nil
        }

        let parentid: String? = dict["parentid"] as? String ?? ""
        
        let reactions: [Reaction]?
        if let reactDict = dict["reactions"] as? NSArray{
            var r = [Reaction]()
            for element in reactDict{
                if let object = element as? [String:Any]{
                    r.append(Reaction.convertIntoModel(response: object))
                }
            }
            reactions = r
        }else{
            reactions = nil
        }
        
        let replycount: Int = dict["replycount"] as? Int ?? 0
        let votecount: Int = dict["votecount"] as? Int ?? 0
        let votescore: Int = dict["votescore"] as? Int ?? 0
        
        let reports: [Report]?
        if let reportDict = dict["reports"] as? NSArray{
            var r = [Report]()
            for element in reportDict{
                if let object = element as? [String:Any]{
                    r.append(Report.from(dict: object))
                }
            }
            reports = r
        }else{
            reports = nil
        }
        let added: Int = dict["added"] as? Int ?? 0
        let modified: Int = dict["modified"] as? Int ?? 0
        
        
        
        return Comment(id: id, conversationid: conversationid, body: body, user: user, parentid: parentid, reactions: reactions, replycount: replycount, votecount: votecount, votescore: votescore, reports: reports, added: added, modified: modified)
        
    }
    
}
