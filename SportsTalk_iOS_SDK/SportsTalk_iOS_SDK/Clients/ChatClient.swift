import Foundation

public protocol ChatClientProtocol {
    func createRoomPostModerated(_ request: ChatRoomsServices.CreateRoomPostmoderated, completionHandler: @escaping Completion<ChatRoom>)
    func createRoomPreModerated(_ request: ChatRoomsServices.CreateRoomPremoderated, completionHandler: @escaping Completion<ChatRoom>)
    func getRoomDetails(_ request: ChatRoomsServices.GetRoomDetails, completionHandler: @escaping Completion<ChatRoom>)
    func deleteRoom(_ request: ChatRoomsServices.DeleteRoom, completionHandler: @escaping Completion<DeleteChatRoomResponse>)
    func updateRoom(_ request: ChatRoomsServices.UpdateRoom, completionHandler: @escaping Completion<ChatRoom>)
    func updateCloseRoom(_ request: ChatRoomsServices.UpdateRoomCloseARoom, completionHandler: @escaping Completion<ChatRoom>)
    func listRooms(_ request: ChatRoomsServices.ListRooms, completionHandler: @escaping Completion<ListRoomsResponse>)
    func listRoomParticipants(_ request: ChatRoomsServices.ListRoomParticipants, completionHandler: @escaping Completion<ListRoomsResponse>)
    func joinRoomAuthenticated(_ request: ChatRoomsServices.JoinRoomAuthenticatedUser, completionHandler: @escaping Completion<JoinChatRoomResponse>)
    func joinRoomByCustomId(_ request: ChatRoomsServices.JoinRoomByCustomId, completionHandler: @escaping Completion<JoinChatRoomResponse>)
    func joinRoomAnonymous(_ request: ChatRoomsServices.JoinRoomAnonymousUser, completionHandler: @escaping Completion<JoinChatRoomResponse>)
    func exitRoom(_ request: ChatRoomsServices.ExitRoom, completionHandler: @escaping Completion<ExitChatRoomResponse>)
    func getUpdates(_ request: ChatRoomsServices.GetUpdates, completionHandler: @escaping Completion<GetUpdatesResponse>)
    func getUpdatesMore(_ request: ChatRoomsServices.GetUpdatesMore, completionHandler: @escaping Completion<GetUpdatesResponse>)
    func executeChatCommand(_ request: ChatRoomsServices.ExecuteChatCommand, completionHandler: @escaping Completion<ExecuteChatCommandResponse>)
    func listMessagesByUser(_ request: ChatRoomsServices.ListMessagesByUser, completionHandler: @escaping Completion<ListMessagesByUser>)
    func reportMessage(_ request: ChatRoomsServices.ReportMessage, completionHandler: @escaping Completion<Event>)
    func reactToAMessage(_ request: ChatRoomsServices.ReactToAMessageLike, completionHandler: @escaping Completion<Event>)
    func startEventUpdates(from room: String, frequency seconds: Double, completionHandler: @escaping Completion<[Event]>)
    func stopEventUpdates()
    
    func approveMessage(_ request: ModerationServices.ApproveMessage, completionHandler: @escaping Completion<Event>)
    func listMessagesNeedingModeration(_ request: ModerationServices.ListMessagesNeedingModeration, completionHandler: @escaping Completion<ListMessagesNeedingModerationResponse>)
    
}

public class ChatClient: NetworkService, ChatClientProtocol {
    var timer: Timer?
    var receivedEvents = [Event]()
    var lastTimeStamp = Date.init(timeIntervalSince1970: 0)
    
    public override init(config: ClientConfig) {
        super.init(config: config)
    }
    
    deinit {
        stopEventUpdates()
    }
}

extension ChatClient {
    public func createRoomPostModerated(_ request: ChatRoomsServices.CreateRoomPostmoderated, completionHandler: @escaping Completion<ChatRoom>) {
        makeRequest(ServiceKeys.chat, withData: request.toDictionary(), requestType: .POST, expectation: ChatRoom.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }

    public func createRoomPreModerated(_ request: ChatRoomsServices.CreateRoomPremoderated, completionHandler: @escaping Completion<ChatRoom>) {
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

    public func joinRoomAuthenticated(_ request: ChatRoomsServices.JoinRoomAuthenticatedUser, completionHandler: @escaping Completion<JoinChatRoomResponse>) {
        makeRequest("\(ServiceKeys.chat)\(request.roomid ?? emptyString)/join", withData: request.toDictionary(), requestType: .POST, expectation: JoinChatRoomResponse.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    public func joinRoomByCustomId(_ request: ChatRoomsServices.JoinRoomByCustomId, completionHandler: @escaping Completion<JoinChatRoomResponse>) {
        makeRequest("\(ServiceKeys.chatCustom)\(request.customid ?? emptyString)/join", withData: request.toDictionary(), requestType: .POST, expectation: JoinChatRoomResponse.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }

    public func joinRoomAnonymous(_ request: ChatRoomsServices.JoinRoomAnonymousUser, completionHandler: @escaping Completion<JoinChatRoomResponse>) {
        makeRequest("\(ServiceKeys.chat)\(request.roomid ?? emptyString)/join", withData: request.toDictionary(), requestType: .POST, expectation: JoinChatRoomResponse.self, append: false) { (response) in
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
    
    public func reactToAMessage(_ request: ChatRoomsServices.ReactToAMessageLike , completionHandler: @escaping Completion<Event>)
    {
        let url = "\(ServiceKeys.chat)\(request.roomId ?? emptyString)/events/\(request.roomNewestEventId ?? emptyString)/react"
        makeRequest(url, withData: request.toDictionary(), requestType: .POST, expectation: Event.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
}


//MARK: - Moderation
extension ChatClient {
    public func approveMessage(_ request: ModerationServices.ApproveMessage , completionHandler: @escaping Completion<Event>) {
        let url = "\(ServiceKeys.chatModeration)\(request.chatMessageId ?? emptyString)/applydecision"
        makeRequest(url, withData: request.toDictionary(), requestType: .POST, expectation: Event.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }

    public func listMessagesNeedingModeration(_ request: ModerationServices.ListMessagesNeedingModeration , completionHandler: @escaping Completion<ListMessagesNeedingModerationResponse>) {
        let url = "chat/moderation/queues/events"
        makeRequest(url, withData: request.toDictionary(), requestType: .GET, expectation: ListMessagesNeedingModerationResponse.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
}

// MARK: - Event Subscription
extension ChatClient {
    public func startEventUpdates(from room: String, frequency seconds: Double = 0.5,  completionHandler: @escaping Completion<[Event]>) {
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
    
    public func stopEventUpdates() {
        timer?.invalidate()
        receivedEvents.removeAll()
    }
}
