import Foundation

public protocol ServicesAMSProtocol
{
    var authToken: String?
    {
        get set
    }
    
    var url: URL?
    {
        get set
    }
    
    var services: Services? { get }

    func usersServices(_ request: UsersServices.CreateUpdateUser, completionHandler: @escaping CompletionHandler)
    func usersServices(_ request: UsersServices.GetUserDetails, completionHandler: @escaping CompletionHandler)
    func usersServices(_ request: UsersServices.ListUsers, completionHandler: @escaping CompletionHandler)
    func usersServices(_ request: UsersServices.ListUsersMore, completionHandler: @escaping CompletionHandler)
    func usersServices(_ request: UsersServices.ListMessagesByUser, completionHandler: @escaping CompletionHandler)
    func usersServices(_ request: UsersServices.SearchUsersByHandle, completionHandler: @escaping CompletionHandler)
    func usersServices(_ request: UsersServices.SearchUsersByName, completionHandler: @escaping CompletionHandler)
    func usersServices(_ request: UsersServices.SearchUsersByUserId, completionHandler: @escaping CompletionHandler)
    
    func webhooksServices(_ request: WebhooksServices.CreateReplaceWebhook, completionHandler: @escaping CompletionHandler)
    func webhooksServices(_ request: WebhooksServices.ListWebhooks, completionHandler: @escaping CompletionHandler)
    func webhooksServices(_ request: WebhooksServices.UpdateWebhook, completionHandler: @escaping CompletionHandler)
    func webhooksServices(_ request: WebhooksServices.DeleteWebhook, completionHandler: @escaping CompletionHandler)

    func moderationServies(_ request: ModerationServices.BanUser, completionHandler: @escaping CompletionHandler)
    func moderationServies(_ request: ModerationServices.RestoreUser, completionHandler: @escaping CompletionHandler)
    func moderationServies(_ request: ModerationServices.PurgeUserMessages, completionHandler: @escaping CompletionHandler)
    func moderationServies(_ request: ModerationServices.DeleteAllEventsInRoom, completionHandler: @escaping CompletionHandler)
    func moderationServies(_ request: ModerationServices.RemoveMessage, completionHandler: @escaping CompletionHandler)
    func moderationServies(_ request: ModerationServices.ReportMessage, completionHandler: @escaping CompletionHandler)
    func moderationServies(_ request: ModerationServices.ApproveMessage , completionHandler: @escaping CompletionHandler)

    func chatRoomsServices(_ request: ChatRoomsServices.CreateRoom , completionHandler: @escaping CompletionHandler)
    func chatRoomsServices(_ request: ChatRoomsServices.UpdateRoom , completionHandler: @escaping CompletionHandler)
    func chatRoomsServices(_ request: ChatRoomsServices.UpdateRoomCloseARoom , completionHandler: @escaping CompletionHandler)
    func chatRoomsServices(_ request: ChatRoomsServices.ListRooms , completionHandler: @escaping CompletionHandler)
    func chatRoomsServices(_ request: ChatRoomsServices.ListRoomParticipants , completionHandler: @escaping CompletionHandler)
    func chatRoomsServices(_ request: ChatRoomsServices.JoinRoomAuthenticatedUser , completionHandler: @escaping CompletionHandler)
    func chatRoomsServices(_ request: ChatRoomsServices.JoinRoomAnonymousUser , completionHandler: @escaping CompletionHandler)
    func chatRoomsServices(_ request: ChatRoomsServices.GetUpdates , completionHandler: @escaping CompletionHandler)
    func chatRoomsServices(_ request: ChatRoomsServices.GetUpdatesMore , completionHandler: @escaping CompletionHandler)
    func chatRoomsServices(_ request: ChatRoomsServices.ExecuteChatCommand , completionHandler: @escaping CompletionHandler)
    func chatRoomsServices(_ request: ChatRoomsServices.ExecuteDanceAction , completionHandler: @escaping CompletionHandler)
    func chatRoomsServices(_ request: ChatRoomsServices.ReplyToAMessage , completionHandler: @escaping CompletionHandler)
    func chatRoomsServices(_ request: ChatRoomsServices.ReactToAMessageLike , completionHandler: @escaping CompletionHandler)
    func chatRoomsServices(_ request: ChatRoomsServices.ExecuteAdminCommand , completionHandler: @escaping CompletionHandler)
    func chatRoomsServices(_ request: ChatRoomsServices.ExitRoom , completionHandler: @escaping CompletionHandler)
    func chatRoomsServices(_ request: ChatRoomsServices.GetRoomDetails , completionHandler: @escaping CompletionHandler)
}

open class ServicesAMS: ServicesBase, ServicesAMSProtocol
{
    public func usersServices(_ request: UsersServices.CreateUpdateUser, completionHandler: @escaping CompletionHandler)
    {
        makeRequest("user/\(request.userid ?? emptyString)", withData: request.toDictionary(), requestType: .POST) { (response) in
            completionHandler(response)
        }
    }
    
    public func usersServices(_ request: UsersServices.GetUserDetails, completionHandler: @escaping CompletionHandler)
    {
        makeRequest("user/\(request.userid ?? emptyString)", withData: request.toDictionary(), requestType: .GET, appendData: false) { (response) in
            completionHandler(response)
        }
    }
    
    public func usersServices(_ request: UsersServices.ListUsers, completionHandler: @escaping CompletionHandler)
    {
        makeRequest("user", withData: request.toDictionary(), requestType: .GET) { (response) in
            completionHandler(response)
        }
    }
    
    public func usersServices(_ request: UsersServices.ListUsersMore, completionHandler: @escaping CompletionHandler)
    {
        makeRequest("user", withData: request.toDictionary(), requestType: .GET) { (response) in
            completionHandler(response)
        }
    }
    
    public func usersServices(_ request: UsersServices.ListMessagesByUser, completionHandler: @escaping CompletionHandler)
    {
        makeRequest("user/\(request.userId ?? emptyString)", withData: request.toDictionary(), requestType: .GET) { (response) in
            completionHandler(response)
        }
    }
    
    public func usersServices(_ request: UsersServices.SearchUsersByHandle, completionHandler: @escaping CompletionHandler)
    {
        makeRequest("user/search", withData: request.toDictionary(), requestType: .POST) { (response) in
            completionHandler(response)
        }
    }
    
    public func usersServices(_ request: UsersServices.SearchUsersByName, completionHandler: @escaping CompletionHandler)
    {
        makeRequest("user/search", withData: request.toDictionary(), requestType: .POST) { (response) in
            completionHandler(response)
        }
    }
    
    public func usersServices(_ request: UsersServices.SearchUsersByUserId, completionHandler: @escaping CompletionHandler)
    {
        makeRequest("user/search", withData: request.toDictionary(), requestType: .POST) { (response) in
            completionHandler(response)
        }
    }
    
    public func webhooksServices(_ request: WebhooksServices.CreateReplaceWebhook, completionHandler: @escaping CompletionHandler)
    {
        makeRequest("webhook", withData: request.toDictionary(), requestType: .POST) { (response) in
            completionHandler(response)
        }
    }
    
    public func webhooksServices(_ request: WebhooksServices.ListWebhooks, completionHandler: @escaping CompletionHandler)
    {
        makeRequest("webhook", withData: request.toDictionary(), requestType: .GET, appendData: false) { (response) in
            completionHandler(response)
        }
    }
    
    public func webhooksServices(_ request: WebhooksServices.UpdateWebhook, completionHandler: @escaping CompletionHandler)
    {
        makeRequest("webhook/\(request.webhookId ?? emptyString)", withData: request.toDictionary(), requestType: .PUT) { (response) in
            completionHandler(response)
        }
    }
    
    public func webhooksServices(_ request: WebhooksServices.DeleteWebhook, completionHandler: @escaping CompletionHandler)
    {
        makeRequest("webhook/\(request.webhookId ?? emptyString)", withData: request.toDictionary(), requestType: .DELETE, appendData: false) { (response) in
            completionHandler(response)
        }
    }
    
    public func moderationServies(_ request: ModerationServices.BanUser, completionHandler: @escaping CompletionHandler)
    {
        makeRequest("user/\(request.userid ?? emptyString)/ban", withData: request.toDictionary(), requestType: .POST) { (response) in
            completionHandler(response)
        }
    }
    
    public func moderationServies(_ request: ModerationServices.RestoreUser, completionHandler: @escaping CompletionHandler)
    {
        makeRequest("user/\(request.userid ?? emptyString)/ban", withData: request.toDictionary(), requestType: .POST) { (response) in
            completionHandler(response)
        }
    }
    
    public func moderationServies(_ request: ModerationServices.PurgeUserMessages, completionHandler: @escaping CompletionHandler)
       {
           makeRequest("room/\(request.chatroomid ?? emptyString)/command", withData: request.toDictionary(), requestType: .POST) { (response) in
               completionHandler(response)
           }
       }
    
    public func moderationServies(_ request: ModerationServices.DeleteAllEventsInRoom, completionHandler: @escaping CompletionHandler)
    {
        makeRequest("room/\(request.chatroomid ?? emptyString)/command", withData: request.toDictionary(), requestType: .POST) { (response) in
            completionHandler(response)
        }
    }
    
    public func moderationServies(_ request: ModerationServices.RemoveMessage, completionHandler: @escaping CompletionHandler)
    {
        makeRequest("room/\(request.chatRoomId ?? emptyString)/remove/\(request.chatMessageId ?? emptyString)", withData: request.toDictionary(), requestType: .POST, appendData: false) { (response) in
            completionHandler(response)
        }
    }
    
    public func moderationServies(_ request: ModerationServices.ReportMessage , completionHandler: @escaping CompletionHandler)
    {
        makeRequest("room/\(request.chatRoomId ?? emptyString)/report/\(request.chatMessageId ?? emptyString)", withData: request.toDictionary(), requestType: .POST, appendData: false) { (response) in
            completionHandler(response)
        }
    }
    
    public func moderationServies(_ request: ModerationServices.ApproveMessage , completionHandler: @escaping CompletionHandler)
    {
        makeRequest("room/\(request.chatRoomId ?? emptyString)/approve/\(request.chatMessageId ?? emptyString)", withData: request.toDictionary(), requestType: .POST, appendData: false) { (response) in
            completionHandler(response)
        }
    }
    
    public func chatRoomsServices(_ request: ChatRoomsServices.CreateRoom , completionHandler: @escaping CompletionHandler)
    {
        makeRequest("room", withData: request.toDictionary(), requestType: .POST) { (response) in
            completionHandler(response)
        }
    }
    
    public func chatRoomsServices(_ request: ChatRoomsServices.UpdateRoom , completionHandler: @escaping CompletionHandler)
    {
        makeRequest("room", withData: request.toDictionary(), requestType: .POST) { (response) in
            completionHandler(response)
        }
    }
    
    public func chatRoomsServices(_ request: ChatRoomsServices.UpdateRoomCloseARoom , completionHandler: @escaping CompletionHandler)
    {
        makeRequest("room/\(request.roomid ?? emptyString)", withData: request.toDictionary(), requestType: .POST) { (response) in
            completionHandler(response)
        }
    }
    
    public func chatRoomsServices(_ request: ChatRoomsServices.ListRooms , completionHandler: @escaping CompletionHandler)
    {
        makeRequest("room", withData: request.toDictionary(), requestType: .GET, appendData: false) { (response) in
            if let responseData = response["data"] as? [AnyHashable: Any] {
                if let knownRooms = responseData["data"] {
                    self.services?.knownRooms = knownRooms
                }
            }
            
            completionHandler(response)
        }
    }
    
    public func chatRoomsServices(_ request: ChatRoomsServices.ListRoomParticipants , completionHandler: @escaping CompletionHandler)
    {
        makeRequest("room/\(request.roomid ?? emptyString)/participants", withData: request.toDictionary(), requestType: .GET) { (response) in
            completionHandler(response)
        }
    }

    public func chatRoomsServices(_ request: ChatRoomsServices.JoinRoomAuthenticatedUser , completionHandler: @escaping CompletionHandler)
    {
        makeRequest("room/\(request.roomid ?? emptyString)/join", withData: request.toDictionary(), requestType: .POST) { (response) in
            completionHandler(response)
        }
    }

    public func chatRoomsServices(_ request: ChatRoomsServices.JoinRoomAnonymousUser , completionHandler: @escaping CompletionHandler)
    {
        makeRequest("room/\(request.roomid ?? emptyString)/join", withData: request.toDictionary(), requestType: .POST) { (response) in
            completionHandler(response)
        }
    }
    
    public func chatRoomsServices(_ request: ChatRoomsServices.GetUpdates , completionHandler: @escaping CompletionHandler)
    {
        makeRequest("room/\(request.roomId ?? emptyString)/updates", withData: request.toDictionary(), requestType: .GET, appendData: false) { (response) in
            completionHandler(response)
        }
    }
    
    public func chatRoomsServices(_ request: ChatRoomsServices.GetUpdatesMore , completionHandler: @escaping CompletionHandler)
    {
        makeRequest("room/\(request.roomIdOrLabel ?? emptyString)/updates", withData: request.toDictionary(), requestType: .GET) { (response) in
            completionHandler(response)
        }
    }
    
    public func chatRoomsServices(_ request: ChatRoomsServices.ExecuteChatCommand , completionHandler: @escaping CompletionHandler)
    {
        makeRequest("room/\(request.roomId ?? emptyString)/command", withData: request.toDictionary(), requestType: .POST) { (response) in
            completionHandler(response)
        }
    }
    
    public func chatRoomsServices(_ request: ChatRoomsServices.ExecuteDanceAction , completionHandler: @escaping CompletionHandler)
    {
        makeRequest("room/\(request.roomId ?? emptyString)/command", withData: request.toDictionary(), requestType: .POST) { (response) in
            completionHandler(response)
        }
    }
    
    public func chatRoomsServices(_ request: ChatRoomsServices.ReplyToAMessage , completionHandler: @escaping CompletionHandler)
    {
        makeRequest("room/\(request.roomId ?? emptyString)/command", withData: request.toDictionary(), requestType: .POST) { (response) in
            completionHandler(response)
        }
    }
    
    public func chatRoomsServices(_ request: ChatRoomsServices.ReactToAMessageLike , completionHandler: @escaping CompletionHandler)
    {
        makeRequest("room/\(request.roomId ?? emptyString)/react/\(request.roomNewestEventId ?? emptyString)", withData: request.toDictionary(), requestType: .POST) { (response) in
            completionHandler(response)
        }
    }
    
    public func chatRoomsServices(_ request: ChatRoomsServices.ExecuteAdminCommand , completionHandler: @escaping CompletionHandler)
    {
        makeRequest("room/\(request.roomId ?? emptyString)/command", withData: request.toDictionary(), requestType: .POST) { (response) in
            completionHandler(response)
        }
    }
    
    public func chatRoomsServices(_ request: ChatRoomsServices.ExitRoom , completionHandler: @escaping CompletionHandler)
    {
        makeRequest("room/\(request.roomId ?? emptyString)/exit", withData: request.toDictionary(), requestType: .POST) { (response) in
            completionHandler(response)
        }
    }
    
    public func chatRoomsServices(_ request: ChatRoomsServices.GetRoomDetails , completionHandler: @escaping CompletionHandler)
    {
        makeRequest("room/\(request.roomIdOrSlug ?? emptyString)", withData: request.toDictionary(), requestType: .GET, appendData: false) { (response) in
            completionHandler(response)
        }
    }
}


