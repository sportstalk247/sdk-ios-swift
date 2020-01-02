import Foundation

open class Services
{
    let baseUrl = URL(string: "http://api-origin.sportstalk247.com/api/v3") // http://api-origin.sportstalk247.com/api/v3
    
    private var _authToken: String?
    private var _url: URL?
    private var _ams = ServicesAMS()
    
//    var lastCursor:Any?
//    var lastMessageId:Any?
//    var firstMessageTime:Any?
//    var firstMessageId: Any?
    var knownRooms: Any?

    open var ams: ServicesAMS
    {
        get
        {
            return _ams
        }
        set
        {
            _ams = newValue
        }
    }

    open var authToken: String?
    {
        get
        {
            return _authToken
        }
        set
        {
            _authToken = newValue
            self.ams.authToken = newValue
        }
    }

    open var url: URL?
    {
        get
        {
            return _url
        }
        set
        {
            _url = newValue
            self.ams.url = newValue
            self.services = self
        }
    }
    
    open var services: Services?


//    public init()
//    {
//        url = baseUrl
//    }
//
//    init(_ url: URL?)
//    {
//        let ret = Services()
//
//        ret.url = url
//    }
//
//    init(_ url: URL?, andAuthToken authToken: String)
//    {
//        let ret = Services(url)
//
//        ret.authToken = authToken
//    }
//    
//    init(authToken: String)
//    {
//        let ret = Services()
//        
//        ret.authToken = authToken
//    }
        
//    func startPollUpdates(currentRoomId:Int, completionHandler: @escaping CompletionHandler)
//    {
//        let getUpdates = ChatRoomsServices.GetUpdates()
//        getUpdates.roomId = String(currentRoomId)
//        
//        ams.chatRoomsServices(getUpdates) { (response) in
//            if let poll = response["data"]
//            {
//                self.handlePoll(poll: poll)
//            }
//        }
//    }
//    
//    func handlePoll(poll:Any)
//    {
//        if let poll = poll as? [AnyHashable: Any]
//        {
//            if let events = poll["data"] as? [[AnyHashable:Any]]
//            {
//                for event in events {
//                    var date = event["added"]
//                    
//                    if lastCursor != nil || date > lastCursor {
//                        lastCursor = date
//                        lastMessageId = event["id"]
//                    }
//                    else
//                    {
//                        if firstMessageTime != nil || date < firstMessageTime
//                        {
//                            firstMessageTime = date
//                            firstMessageId = event["id"]
//                        }
//                        
//                        continue
//                    }
//                    
//                    if (event["eventtype"] == types_1.EventType.purge && _this._onPurgeEvent) {
//                        _this._onPurgeEvent(event_1.user.userid, event_1.user.handle, event_1);
//                        continue;
//                    }
//                    if (event_1.eventtype == types_1.EventType.reaction && _this._onReaction) {
//                        _this._onReaction(event_1);
//                        continue;
//                    }
//                    if (_this._onChatEvent) {
//                        _this._onChatEvent(event_1, event_1.userid == _this._userId);
//                        continue;
//                    }
//                }
//            }
//        }
//        
//    }
    
}
