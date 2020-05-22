import Foundation

public protocol ChatClientProtocol {
    func createRoom(_ request: ChatRoomsServices.CreateRoom, completionHandler: @escaping Completion<ChatRoom>)
    func getRoomDetails(_ request: ChatRoomsServices.GetRoomDetails, completionHandler: @escaping Completion<ChatRoom>)
    func deleteRoom(_ request: ChatRoomsServices.DeleteRoom, completionHandler: @escaping Completion<DeleteChatRoomResponse>)
    func updateRoom(_ request: ChatRoomsServices.UpdateRoom, completionHandler: @escaping Completion<ChatRoom>)
    func updateCloseRoom(_ request: ChatRoomsServices.UpdateRoomCloseARoom, completionHandler: @escaping Completion<ChatRoom>)
    func listRooms(_ request: ChatRoomsServices.ListRooms, completionHandler: @escaping Completion<ListRoomsResponse>)
    func listRoomParticipants(_ request: ChatRoomsServices.ListRoomParticipants, completionHandler: @escaping Completion<ListRoomsResponse>)
    func joinRoom(_ request: ChatRoomsServices.JoinRoom, completionHandler: @escaping Completion<JoinChatRoomResponse>)
    func joinRoomByCustomId(_ request: ChatRoomsServices.JoinRoomByCustomId, completionHandler: @escaping Completion<JoinChatRoomResponse>)
    func exitRoom(_ request: ChatRoomsServices.ExitRoom, completionHandler: @escaping Completion<ExitChatRoomResponse>)
    func getUpdates(_ request: ChatRoomsServices.GetUpdates, completionHandler: @escaping Completion<GetUpdatesResponse>)
    func getUpdatesMore(_ request: ChatRoomsServices.GetUpdatesMore, completionHandler: @escaping Completion<GetUpdatesResponse>)
    func executeChatCommand(_ request: ChatRoomsServices.ExecuteChatCommand, completionHandler: @escaping Completion<ExecuteChatCommandResponse>)
    func sendReply(_ request: ChatRoomsServices.SendReply, completionHandler: @escaping Completion<ExecuteChatCommandResponse>)
    func listMessagesByUser(_ request: ChatRoomsServices.ListMessagesByUser, completionHandler: @escaping Completion<ListMessagesByUser>)
    func reportMessage(_ request: ChatRoomsServices.ReportMessage, completionHandler: @escaping Completion<Event>)
    func reactToEvent(_ request: ChatRoomsServices.ReactToEvent, completionHandler: @escaping Completion<Event>)
    func startListeningToChatUpdates(from room: String, frequency seconds: Double, completionHandler: @escaping Completion<[Event]>)
    func stopListeningToChatUpdates()
    
    func approveEvent(_ request: ModerationServices.ApproveEvent, completionHandler: @escaping Completion<Event>)
    func rejectEvent(_ request: ModerationServices.RejectEvent, completionHandler: @escaping Completion<Event>)
    func listMessagesInModerationQueue(_ request: ModerationServices.listMessagesInModerationQueue, completionHandler: @escaping Completion<ListMessagesNeedingModerationResponse>)
    
    
    /* Deprecated */
    func joinRoomAuthenticated(_ request: ChatRoomsServices.JoinRoomAuthenticatedUser, completionHandler: @escaping Completion<JoinChatRoomResponse>)
    func joinRoomAnonymous(_ request: ChatRoomsServices.JoinRoomAnonymousUser, completionHandler: @escaping Completion<JoinChatRoomResponse>)
    func createRoomPostModerated(_ request: ChatRoomsServices.CreateRoomPostmoderated, completionHandler: @escaping Completion<ChatRoom>)
    func createRoomPreModerated(_ request: ChatRoomsServices.CreateRoomPremoderated, completionHandler: @escaping Completion<ChatRoom>)
}

public class ChatClient: NetworkService, ChatClientProtocol {
    var timer: Timer?
    var receivedEvents = [Event]()
    var lastTimeStamp = Date.init(timeIntervalSince1970: 0)
    
    public override init(config: ClientConfig) {
        super.init(config: config)
    }
    
    deinit {
        stopListeningToChatUpdates()
    }
}

extension ChatClient {
    public func createRoom(_ request: ChatRoomsServices.CreateRoom, completionHandler: @escaping Completion<ChatRoom>) {
        makeRequest(ServiceKeys.chat, withData: request.toDictionary(), requestType: .POST, expectation: ChatRoom.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    public func getRoomDetails(_ request: ChatRoomsServices.GetRoomDetails, completionHandler: @escaping Completion<ChatRoom>) {
        makeRequest(ServiceKeys.chat, withData: request.toDictionary(), requestType: .GET, expectation: ChatRoom.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }

    public func deleteRoom(_ request: ChatRoomsServices.DeleteRoom, completionHandler: @escaping Completion<DeleteChatRoomResponse>) {
        makeRequest("\(ServiceKeys.chat)\(request.roomid ?? "")", withData: request.toDictionary(), requestType: .DELETE, expectation: DeleteChatRoomResponse.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }

    public func updateRoom(_ request: ChatRoomsServices.UpdateRoom, completionHandler: @escaping Completion<ChatRoom>) {
        makeRequest("\(ServiceKeys.chat)\(request.roomid ?? "")", withData: request.toDictionary(), requestType: .POST, expectation: ChatRoom.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }

    public func updateCloseRoom(_ request: ChatRoomsServices.UpdateRoomCloseARoom, completionHandler: @escaping Completion<ChatRoom>) {
        makeRequest("\(ServiceKeys.chat)\(request.roomid ?? emptyString)", withData: request.toDictionary(), requestType: .POST, expectation: ChatRoom.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }

    public func listRooms(_ request: ChatRoomsServices.ListRooms, completionHandler: @escaping Completion<ListRoomsResponse>) {
        makeRequest(ServiceKeys.chat, withData: request.toDictionary(), requestType: .GET, expectation: ListRoomsResponse.self, append: false) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }

    }

    public func listRoomParticipants(_ request: ChatRoomsServices.ListRoomParticipants, completionHandler: @escaping Completion<ListRoomsResponse>) {
        makeRequest("\(ServiceKeys.chat)\(request.roomid ?? emptyString)/participants", withData: request.toDictionary(), requestType: .GET, expectation: ListRoomsResponse.self, append: false) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    public func joinRoom(_ request: ChatRoomsServices.JoinRoom, completionHandler: @escaping Completion<JoinChatRoomResponse>) {
        makeRequest("\(ServiceKeys.chat)\(request.roomid ?? emptyString)/join", withData: request.toDictionary(), requestType: .POST, expectation: JoinChatRoomResponse.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    public func joinRoomByCustomId(_ request: ChatRoomsServices.JoinRoomByCustomId, completionHandler: @escaping Completion<JoinChatRoomResponse>) {
        makeRequest("\(ServiceKeys.chatCustom)\(request.customid ?? emptyString)/join", withData: request.toDictionary(), requestType: .POST, expectation: JoinChatRoomResponse.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }

    public func exitRoom(_ request: ChatRoomsServices.ExitRoom, completionHandler: @escaping Completion<ExitChatRoomResponse>) {
        makeRequest("\(ServiceKeys.chat)\(request.roomId ?? emptyString)/exit", withData: request.toDictionary(), requestType: .POST, expectation: ExitChatRoomResponse.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }

    public func getUpdates(_ request: ChatRoomsServices.GetUpdates, completionHandler: @escaping Completion<GetUpdatesResponse>) {
        makeRequest("\(ServiceKeys.chat)\(request.roomId ?? emptyString)/updates", withData: request.toDictionary(), requestType: .GET, expectation: GetUpdatesResponse.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }

    public func getUpdatesMore(_ request: ChatRoomsServices.GetUpdatesMore, completionHandler: @escaping Completion<GetUpdatesResponse>) {
        makeRequest("\(ServiceKeys.chat)\(request.roomIdOrLabel ?? emptyString)/updates", withData: request.toDictionary(), requestType: .GET, expectation: GetUpdatesResponse.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }

    public func executeChatCommand(_ request: ChatRoomsServices.ExecuteChatCommand, completionHandler: @escaping Completion<ExecuteChatCommandResponse>) {
        makeRequest("\(ServiceKeys.chat)\(request.roomId ?? emptyString)/command", withData: request.toDictionary(), requestType: .POST, expectation: ExecuteChatCommandResponse.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    public func sendReply(_ request: ChatRoomsServices.SendReply, completionHandler: @escaping Completion<ExecuteChatCommandResponse>) {
        makeRequest("\(ServiceKeys.chat)\(request.roomId ?? emptyString)/command", withData: request.toDictionary(), requestType: .POST, expectation: ExecuteChatCommandResponse.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }

    public func listMessagesByUser(_ request: ChatRoomsServices.ListMessagesByUser, completionHandler: @escaping Completion<ListMessagesByUser>) {
        makeRequest("\(ServiceKeys.chat)\(request.roomid ?? emptyString)/messagesbyuser/\(request.userId ?? emptyString)", withData: request.toDictionary(), requestType: .GET, expectation: ListMessagesByUser.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }

    public func reportMessage(_ request: ChatRoomsServices.ReportMessage, completionHandler: @escaping Completion<Event>) {
        makeRequest("\(ServiceKeys.chat)\(request.chatRoomId ?? emptyString)/events/\(request.chat_room_newest_speech_id ?? emptyString)/report", withData: request.toDictionary(), requestType: .POST, expectation: Event.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    public func reactToEvent(_ request: ChatRoomsServices.ReactToEvent, completionHandler: @escaping Completion<Event>) {
        let url = "\(ServiceKeys.chat)\(request.roomId ?? emptyString)/events/\(request.eventid ?? emptyString)/react"
        makeRequest(url, withData: request.toDictionary(), requestType: .POST, expectation: Event.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
}


//MARK: - Moderation
extension ChatClient {
    public func approveEvent(_ request: ModerationServices.ApproveEvent, completionHandler: @escaping Completion<Event>) {
        let url = "\(ServiceKeys.chatModeration)\(request.chatMessageId ?? emptyString)/applydecision"
        makeRequest(url, withData: request.toDictionary(), requestType: .POST, expectation: Event.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }

    public func rejectEvent(_ request: ModerationServices.RejectEvent, completionHandler: @escaping Completion<Event>) {
        let url = "\(ServiceKeys.chatModeration)\(request.chatMessageId ?? emptyString)/applydecision"
        makeRequest(url, withData: request.toDictionary(), requestType: .POST, expectation: Event.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    public func listMessagesInModerationQueue(_ request: ModerationServices.listMessagesInModerationQueue, completionHandler: @escaping Completion<ListMessagesNeedingModerationResponse>) {
        let url = "chat/moderation/queues/events"
        makeRequest(url, withData: request.toDictionary(), requestType: .GET, expectation: ListMessagesNeedingModerationResponse.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
}

// MARK: - Event Subscription
extension ChatClient {
    public func startListeningToChatUpdates(from room: String, frequency seconds: Double = 0.5,  completionHandler: @escaping Completion<[Event]>) {
        let request = ChatRoomsServices.GetUpdates()
        request.roomId = room
            
        timer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: true, block: { _ in
            self.getUpdates(request) { (code, message, kind, response) in
                if let response = response {
                    var emittableEvents = [Event]()
                    
                    for event in response.events {
                        if let timestamp = event.ts {
                            if timestamp > self.lastTimeStamp {
                                self.lastTimeStamp = timestamp
                                emittableEvents.append(event)
                            }
                        }
                    }
                    
                    completionHandler(code, message, kind, emittableEvents)
                }
            }
        })
    }
    
    public func stopListeningToChatUpdates() {
        timer?.invalidate()
        receivedEvents.removeAll()
    }
}

// MARK: - Deprecated
extension ChatClient {
    @available(swift, deprecated: 5, renamed: "JoinRoom", message: "Use JoinRoom with a user")
    public func joinRoomAuthenticated(_ request: ChatRoomsServices.JoinRoomAuthenticatedUser, completionHandler: @escaping Completion<JoinChatRoomResponse>) {
        makeRequest("\(ServiceKeys.chat)\(request.roomid ?? emptyString)/join", withData: request.toDictionary(), requestType: .POST, expectation: JoinChatRoomResponse.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    @available(swift, deprecated: 5, renamed: "JoinRoom", message: "Use JoinRoom without setting a user")
    public func createRoomPostModerated(_ request: ChatRoomsServices.CreateRoomPostmoderated, completionHandler: @escaping Completion<ChatRoom>) {
        makeRequest(ServiceKeys.chat, withData: request.toDictionary(), requestType: .POST, expectation: ChatRoom.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }

    @available(swift, deprecated: 5, renamed: "CreateRoom", message: "Use CreateRoom with request.moderation = \"post\"")
    public func createRoomPreModerated(_ request: ChatRoomsServices.CreateRoomPremoderated, completionHandler: @escaping Completion<ChatRoom>) {
        makeRequest(ServiceKeys.chat, withData: request.toDictionary(), requestType: .POST, expectation: ChatRoom.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    @available(swift, deprecated: 5, renamed: "CreateRoom", message: "Use CreateRoom with request.moderation = \"pre\"")
    public func joinRoomAnonymous(_ request: ChatRoomsServices.JoinRoomAnonymousUser, completionHandler: @escaping Completion<JoinChatRoomResponse>) {
        makeRequest("\(ServiceKeys.chat)\(request.roomid ?? emptyString)/join", withData: request.toDictionary(), requestType: .POST, expectation: JoinChatRoomResponse.self, append: false) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
}
