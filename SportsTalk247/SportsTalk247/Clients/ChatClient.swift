import Foundation

public protocol ChatClientProtocol {
    func createRoom(_ request: ChatRequest.CreateRoom, completionHandler: @escaping Completion<ChatRoom>)
    func getRoomDetails(_ request: ChatRequest.GetRoomDetails, completionHandler: @escaping Completion<ChatRoom>)
    func getRoomDetailsByCustomId(_ request: ChatRequest.GetRoomDetailsByCustomId, completionHandler: @escaping Completion<ChatRoom>)
    func deleteRoom(_ request: ChatRequest.DeleteRoom, completionHandler: @escaping Completion<DeleteChatRoomResponse>)
    func updateRoom(_ request: ChatRequest.UpdateRoom, completionHandler: @escaping Completion<ChatRoom>)
    func updateCloseRoom(_ request: ChatRequest.UpdateRoomCloseARoom, completionHandler: @escaping Completion<ChatRoom>)
    func listRooms(_ request: ChatRequest.ListRooms, completionHandler: @escaping Completion<ListRoomsResponse>)
    func listRoomParticipants(_ request: ChatRequest.ListRoomParticipants, completionHandler: @escaping Completion<ListChatRoomParticipantsResponse>)
    func listEventHistory(_ request: ChatRequest.ListEventHistory, completionHandler: @escaping Completion<ListEventsResponse>)
    func listPreviousEvents(_ request: ChatRequest.ListPreviousEvents, completionHandler: @escaping Completion<ListEventsResponse>)
    func listEventByType(_ request: ChatRequest.ListEventByType, completionHandler: @escaping Completion<ListEventsResponse>)
    func listEventByTimestamp(_ request: ChatRequest.ListEventByTimestamp, completionHandler: @escaping Completion<ListEventByTimestampResponse>)
    func joinRoom(_ request: ChatRequest.JoinRoom, completionHandler: @escaping Completion<JoinChatRoomResponse>)
    func joinRoomByCustomId(_ request: ChatRequest.JoinRoomByCustomId, completionHandler: @escaping Completion<JoinChatRoomResponse>)
    func exitRoom(_ request: ChatRequest.ExitRoom, completionHandler: @escaping Completion<ExitChatRoomResponse>)
    func getUpdates(_ request: ChatRequest.GetUpdates, completionHandler: @escaping Completion<GetUpdatesResponse>)
    func getMoreUpdates(_ request: ChatRequest.GetMoreUpdates, completionHandler: @escaping Completion<GetUpdatesResponse>)
    func executeChatCommand(_ request: ChatRequest.ExecuteChatCommand, completionHandler: @escaping Completion<ExecuteChatCommandResponse>) throws
    func sendQuotedReply(_ request: ChatRequest.SendQuotedReply, completionHandler: @escaping Completion<Event>) throws
    func sendThreadedReply(_ request: ChatRequest.SendThreadedReply, completionHandler: @escaping Completion<Event>) throws
    func purgeMessage(_ request: ChatRequest.PurgeUserMessages, completionHandler: @escaping Completion<ExecuteChatCommandResponse>)
    func flagEventLogicallyDeleted(_ request: ChatRequest.FlagEventLogicallyDeleted, completionHandler: @escaping Completion<DeleteEventResponse>)
    func permanentlyDeleteEvent(_ request: ChatRequest.PermanentlyDeleteEvent, completionHandler: @escaping Completion<DeleteEventResponse>)
    func deleteAllEvents(_ request: ChatRequest.DeleteAllEvents, completionHandler: @escaping Completion<ExecuteChatCommandResponse>)
    func listMessagesByUser(_ request: ChatRequest.ListMessagesByUser, completionHandler: @escaping Completion<ListMessagesByUser>)
    func reportMessage(_ request: ChatRequest.ReportMessage, completionHandler: @escaping Completion<Event>)
    func reactToEvent(_ request: ChatRequest.ReactToEvent, completionHandler: @escaping Completion<Event>)
    func reportUserInRoom(_ request: ChatRequest.ReportUserInRoom, completionHandler: @escaping Completion<ChatRoom>)
    func bounceUser(_ request: ChatRequest.BounceUser, completionHandler: @escaping Completion<BounceUserResponse>)
    func shadowbanUser(_ request: ChatRequest.ShadowbanUser, completionHandler: @escaping Completion<ChatRoom>)
    func muteUser(_ request: ChatRequest.MuteUser, completionHandler: @escaping Completion<ChatRoom>)
    func searchEventHistory(_ request: ChatRequest.SearchEvent, completionHandler: @escaping Completion<ListEventsResponse>)
    func updateChatEvent(_ request: ChatRequest.UpdateChatEvent, completionHandler: @escaping Completion<Event>)
    
    func startListeningToChatUpdates(limit: Int?, completionHandler: @escaping Completion<[Event]>)
    func stopListeningToChatUpdates()
    
    func approveEvent(_ request: ModerationRequest.ApproveEvent, completionHandler: @escaping Completion<Event>)
    func rejectEvent(_ request: ModerationRequest.RejectEvent, completionHandler: @escaping Completion<Event>)
    func listMessagesInModerationQueue(_ request: ModerationRequest.listMessagesInModerationQueue, completionHandler: @escaping Completion<ListMessagesNeedingModerationResponse>)
    
    func messageIsReactedTo(_ userid: String, event: Event?) -> Bool
    func messageIsReported(_ userid: String, event: Event?) -> Bool
}

public class ChatClient: NetworkService, ChatClientProtocol {
    var timer: Timer?
    var firstcursor: String = ""
    var lastcursor: String = ""
    var lastroomid: String?
    var lastcommand: String?
    var lastcommandsent: Date?
    var currentuserid: String?
    static let timeout = 20000 // milliseconds
    
    public override init(config: ClientConfig) {
        super.init(config: config)
    }
    
    deinit {
        stopListeningToChatUpdates()
    }
}

// MARK: - Convenience
extension ChatClient {
    private func throttle(command: String?) -> Bool {
        guard command != nil else {
            if SportsTalkSDK.shared.debugMode {
                print("SDK Error: Missing command string.")
                print("sent command: \(String(describing: command))")
            }
            return false
        }
        
        guard let lastCommand = self.lastcommand, let lastSent = self.lastcommandsent else {
            return true
        }
        
        var allow = false
        
        if command == lastCommand {
            let milliseconds = Date().difference(between: Date(), and: lastSent) * 1000
            
            if milliseconds >= ChatClient.timeout {
                allow = true
            } else {
                if SportsTalkSDK.shared.debugMode {
                    print("SDK Error: Command is being sent too frequently. Please wait \(ChatClient.timeout)ms until you send another.")
                    print("command: \(String(describing: command))")
                    print("last sent (ms): \(milliseconds)")
                }
                allow = false
            }
        } else {
            allow = true
        }
        
        return allow
    }
}

extension ChatClient {
    public func createRoom(_ request: ChatRequest.CreateRoom, completionHandler: @escaping Completion<ChatRoom>) {
        makeRequest(URLPath.Room.Create(), withData: request.toDictionary(), requestType: .POST, expectation: ChatRoom.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    public func getRoomDetails(_ request: ChatRequest.GetRoomDetails, completionHandler: @escaping Completion<ChatRoom>) {
        makeRequest(URLPath.Room.Details(roomid: request.roomid), withData: request.toDictionary(), requestType: .GET, expectation: ChatRoom.self, append: false) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    public func getRoomDetailsByCustomId(_ request: ChatRequest.GetRoomDetailsByCustomId, completionHandler: @escaping Completion<ChatRoom>) {
        makeRequest(URLPath.Room.DetailsByCustomId(customid: request.customid), withData: request.toDictionary(), requestType: .GET, expectation: ChatRoom.self, append: false) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }

    public func deleteRoom(_ request: ChatRequest.DeleteRoom, completionHandler: @escaping Completion<DeleteChatRoomResponse>) {
        makeRequest(URLPath.Room.Delete(roomid: request.roomid), withData: request.toDictionary(), requestType: .DELETE, expectation: DeleteChatRoomResponse.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }

    public func updateRoom(_ request: ChatRequest.UpdateRoom, completionHandler: @escaping Completion<ChatRoom>) {
        makeRequest(URLPath.Room.Update(roomid: request.roomid), withData: request.toDictionary(), requestType: .POST, expectation: ChatRoom.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }

    public func updateCloseRoom(_ request: ChatRequest.UpdateRoomCloseARoom, completionHandler: @escaping Completion<ChatRoom>) {
        makeRequest(URLPath.Room.Close(roomid: request.roomid), withData: request.toDictionary(), requestType: .POST, expectation: ChatRoom.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }

    public func listRooms(_ request: ChatRequest.ListRooms, completionHandler: @escaping Completion<ListRoomsResponse>) {
        makeRequest(URLPath.Room.List(), withData: request.toDictionary(), requestType: .GET, expectation: ListRoomsResponse.self, append: true) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }

    public func listRoomParticipants(_ request: ChatRequest.ListRoomParticipants, completionHandler: @escaping Completion<ListChatRoomParticipantsResponse>) {
        makeRequest(URLPath.Room.Participants(roomid: request.roomid), withData: request.toDictionary(), requestType: .GET, expectation: ListChatRoomParticipantsResponse.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    public func listEventHistory(_ request: ChatRequest.ListEventHistory, completionHandler: @escaping Completion<ListEventsResponse>) {
        makeRequest(URLPath.Room.EventHistory(roomid: request.roomid), withData: request.toDictionary(), requestType: .GET, expectation: ListEventsResponse.self) { (response) in
            
            // Filter shadowbanned events that are not from user
            var data = response?.data
            data?.events.removeAll(where: ({ $0.shadowban == true && $0.userid != self.currentuserid }))
            
            completionHandler(response?.code, response?.message, response?.kind, data)
        }
    }
    
    public func listPreviousEvents(_ request: ChatRequest.ListPreviousEvents,completionHandler: @escaping Completion<ListEventsResponse>) {
        request.cursor = request.cursor ?? self.firstcursor
        makeRequest(URLPath.Room.PreviousEvent(roomid: request.roomid), withData: request.toDictionary(), requestType: .GET, expectation: ListEventsResponse.self, append: true) { (response) in
            
            // Filter shadowbanned events that are not from user
            var data = response?.data
            data?.events.removeAll(where: ({ $0.shadowban == true && $0.userid != self.currentuserid }))
            
            completionHandler(response?.code, response?.message, response?.kind, data)
            self.firstcursor = response?.data?.cursor ?? ""
        }
    }
    
    public func listEventByType(_ request: ChatRequest.ListEventByType,completionHandler: @escaping Completion<ListEventsResponse>) {
        makeRequest(URLPath.Room.EventByType(roomid: request.roomid), withData: request.toDictionary(), requestType: .GET, expectation: ListEventsResponse.self, append: true) { (response) in
            
            // Filter shadowbanned events that are not from user
            var data = response?.data
            data?.events.removeAll(where: ({ $0.shadowban == true && $0.userid != self.currentuserid }))
            
            completionHandler(response?.code, response?.message, response?.kind, data)
            self.firstcursor = response?.data?.cursor ?? ""
        }
    }
    
    public func listEventByTimestamp(_ request: ChatRequest.ListEventByTimestamp,completionHandler: @escaping Completion<ListEventByTimestampResponse>) {
        makeRequest(URLPath.Room.EventByTime(roomid: request.roomid, time: request.timestamp), withData: request.toDictionary(), requestType: .GET, expectation: ListEventByTimestampResponse.self, append: true) { (response) in
            
            // Filter shadowbanned events that are not from user
            var data = response?.data
            data?.events.removeAll(where: ({ $0.shadowban == true && $0.userid != self.currentuserid }))
            
            completionHandler(response?.code, response?.message, response?.kind, data)
            self.firstcursor = response?.data?.cursornewer ?? ""
        }   
    }
    
    public func joinRoom(_ request: ChatRequest.JoinRoom, completionHandler: @escaping Completion<JoinChatRoomResponse>) {
        makeRequest(URLPath.Room.Join(roomid: request.roomid), withData: request.toDictionary(), requestType: .POST, expectation: JoinChatRoomResponse.self) { (response) in
            self.lastroomid = request.roomid
            self.lastcursor = ""
            self.firstcursor = response?.data?.eventscursor?.cursor ?? ""
            self.currentuserid = request.userid
            
            let newupdates = GetUpdatesResponse()
            newupdates.kind = response?.data?.eventscursor?.kind
            newupdates.cursor = response?.data?.eventscursor?.cursor
            newupdates.more = response?.data?.eventscursor?.more
            newupdates.itemcount = response?.data?.eventscursor?.itemcount
            newupdates.room = response?.data?.eventscursor?.room
            newupdates.events = response?.data?.eventscursor?.events ?? []

            // Filter shadowbanned events that are not from user
            newupdates.events.removeAll(where: ({ $0.shadowban == true && $0.userid != self.currentuserid }))
            
            let newdata = JoinChatRoomResponse()
            newdata.kind = response?.data?.kind
            newdata.user = response?.data?.user
            newdata.room = response?.data?.room
            newdata.eventscursor = newupdates
            newdata.previouseventscursor = response?.data?.previouseventscursor
            
            completionHandler(response?.code, response?.message, response?.kind, newdata)
        }
    }
    
    public func joinRoomByCustomId(_ request: ChatRequest.JoinRoomByCustomId, completionHandler: @escaping Completion<JoinChatRoomResponse>) {
        makeRequest(URLPath.Room.Join(customid: request.customid), withData: request.toDictionary(), requestType: .POST, expectation: JoinChatRoomResponse.self) { (response) in
            self.lastcursor = ""
            self.firstcursor = response?.data?.eventscursor?.cursor ?? ""
            self.lastroomid = response?.data?.room?.id ?? ""
            self.currentuserid = request.userid
            
            let newupdates = GetUpdatesResponse()
            newupdates.kind = response?.data?.eventscursor?.kind
            newupdates.cursor = response?.data?.eventscursor?.cursor
            newupdates.more = response?.data?.eventscursor?.more
            newupdates.itemcount = response?.data?.eventscursor?.itemcount
            newupdates.room = response?.data?.eventscursor?.room
            newupdates.events = response?.data?.eventscursor?.events ?? []

            // Filter shadowbanned events that are not from user
            newupdates.events.removeAll(where: ({ $0.shadowban == true && $0.userid != self.currentuserid }))
            
            let newdata = JoinChatRoomResponse()
            newdata.kind = response?.data?.kind
            newdata.user = response?.data?.user
            newdata.room = response?.data?.room
            newdata.eventscursor = newupdates
            newdata.previouseventscursor = response?.data?.previouseventscursor
            
            completionHandler(response?.code, response?.message, response?.kind, newdata)
        }
    }

    public func exitRoom(_ request: ChatRequest.ExitRoom, completionHandler: @escaping Completion<ExitChatRoomResponse>) {
        makeRequest(URLPath.Room.Exit(roomid: request.roomid), withData: request.toDictionary(), requestType: .POST, expectation: ExitChatRoomResponse.self) { (response) in
            self.stopListeningToChatUpdates()
            self.lastroomid = nil
            self.lastcursor = ""
            self.currentuserid = nil
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }

    public func getUpdates(_ request: ChatRequest.GetUpdates, completionHandler: @escaping Completion<GetUpdatesResponse>) {
        makeRequest(URLPath.Room.GetUpdates(roomid: request.roomid), withData: request.toDictionary(), requestType: .GET, expectation: GetUpdatesResponse.self, append: true) { (response) in
            
            // Filter shadowbanned events that are not from user
            let data = response?.data
            data?.events.removeAll(where: ({ $0.shadowban == true && $0.userid != self.currentuserid }))
            
            completionHandler(response?.code, response?.message, response?.kind, data)
        }
    }
    
    public func getMoreUpdates(_ request: ChatRequest.GetMoreUpdates, completionHandler: @escaping Completion<GetUpdatesResponse>) {
        makeRequest(URLPath.Room.GetUpdates(roomid: request.roomid), withData: request.toDictionary(), requestType: .GET, expectation: GetUpdatesResponse.self, append: true) { (response) in
            
            // Filter shadowbanned events that are not from user
            let data = response?.data
            data?.events.removeAll(where: ({ $0.shadowban == true && $0.userid != self.currentuserid }))
            
            completionHandler(response?.code, response?.message, response?.kind, data)
        }
    }

    public func executeChatCommand(_ request: ChatRequest.ExecuteChatCommand, completionHandler: @escaping Completion<ExecuteChatCommandResponse>) throws {
        guard throttle(command: request.command) else { throw SDKError.NotAllowed }
        
        makeRequest(URLPath.Room.ExecuteCommand(roomid: request.roomid), withData: request.toDictionary(), requestType: .POST, expectation: ExecuteChatCommandResponse.self) { (response) in
            self.lastcommand = request.command
            self.lastcommandsent = Date()
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    public func sendQuotedReply(_ request: ChatRequest.SendQuotedReply, completionHandler: @escaping Completion<Event>) throws {
        guard throttle(command: request.body) else { throw SDKError.NotAllowed }
        
        makeRequest(URLPath.Room.QuotedReply(roomid: request.roomid, eventid: request.eventid), withData: request.toDictionary(), requestType: .POST, expectation: Event.self) { (response) in
            self.lastcommand = request.body
            self.lastcommandsent = Date()
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    public func sendThreadedReply(_ request: ChatRequest.SendThreadedReply, completionHandler: @escaping Completion<Event>) throws {
        guard throttle(command: request.body) else { throw SDKError.NotAllowed }
        
        makeRequest(URLPath.Room.ThreadedReply(roomid: request.roomid, eventid: request.eventid), withData: request.toDictionary(), requestType: .POST, expectation: Event.self) { (response) in
            self.lastcommand = request.body
            self.lastcommandsent = Date()
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    
    public func purgeMessage(_ request: ChatRequest.PurgeUserMessages, completionHandler: @escaping Completion<ExecuteChatCommandResponse>) {
        makeRequest(URLPath.Event.Purge(roomid: request.roomid, userid: request.userid), withData: request.toDictionary(), requestType: .POST, expectation: ExecuteChatCommandResponse.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    public func flagEventLogicallyDeleted(_ request: ChatRequest.FlagEventLogicallyDeleted, completionHandler: @escaping Completion<DeleteEventResponse>) {
        makeRequest(URLPath.Event.FlagLogicallyDeleted(roomid: request.roomid, eventid: request.eventid), withData: request.toDictionary(), requestType: .PUT, expectation: DeleteEventResponse.self, append: true) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }

    public func permanentlyDeleteEvent(_ request: ChatRequest.PermanentlyDeleteEvent, completionHandler: @escaping Completion<DeleteEventResponse>) {
        makeRequest(URLPath.Event.Delete(roomid: request.roomid, eventid: request.eventid), withData: request.toDictionary(), requestType: .DELETE, expectation: DeleteEventResponse.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    public func deleteAllEvents(_ request: ChatRequest.DeleteAllEvents, completionHandler: @escaping Completion<ExecuteChatCommandResponse>) {
        makeRequest(URLPath.Event.DeleteAll(roomid: request.roomid), withData: request.toDictionary(), requestType: .POST, expectation: ExecuteChatCommandResponse.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }

    public func listMessagesByUser(_ request: ChatRequest.ListMessagesByUser, completionHandler: @escaping Completion<ListMessagesByUser>) {
        makeRequest(URLPath.Event.ListByUser(roomid: request.roomid, userid: request.userId), withData: request.toDictionary(), requestType: .GET, expectation: ListMessagesByUser.self, append: true) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }

    public func reportMessage(_ request: ChatRequest.ReportMessage, completionHandler: @escaping Completion<Event>) {
        makeRequest(URLPath.Event.Report(roomid: request.roomid, eventid: request.eventid), withData: request.toDictionary(), requestType: .POST, expectation: Event.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    public func reactToEvent(_ request: ChatRequest.ReactToEvent, completionHandler: @escaping Completion<Event>) {
        makeRequest(URLPath.Event.React(roomid: request.roomid, eventid: request.eventid), withData: request.toDictionary(), requestType: .POST, expectation: Event.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    public func reportUserInRoom(_ request: ChatRequest.ReportUserInRoom, completionHandler: @escaping Completion<ChatRoom>) {
        makeRequest(URLPath.Room.Report(roomid: request.roomid, userid: request.reporteduserid), withData: request.toDictionary(), requestType: .POST, expectation: ChatRoom.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    public func bounceUser(_ request: ChatRequest.BounceUser, completionHandler: @escaping Completion<BounceUserResponse>) {
        makeRequest(URLPath.Room.Bounce(roomid: request.roomid), withData: request.toDictionary(), requestType: .POST, expectation: BounceUserResponse.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    public func shadowbanUser(_ request: ChatRequest.ShadowbanUser, completionHandler: @escaping Completion<ChatRoom>) {
        makeRequest(URLPath.Room.Shadowban(roomid: request.roomid), withData: request.toDictionary(), requestType: .POST, expectation: ChatRoom.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    public func muteUser(_ request: ChatRequest.MuteUser, completionHandler: @escaping Completion<ChatRoom>) {
        makeRequest(URLPath.Room.Mute(roomid: request.roomid), withData: request.toDictionary(), requestType: .POST, expectation: ChatRoom.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    public func searchEventHistory(_ request: ChatRequest.SearchEvent, completionHandler: @escaping Completion<ListEventsResponse>) {
        makeRequest(URLPath.Room.SearchEvent(), withData: request.toDictionary(), requestType: .POST, expectation: ListEventsResponse.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    public func updateChatEvent(_ request: ChatRequest.UpdateChatEvent, completionHandler: @escaping Completion<Event>) {
        makeRequest(URLPath.Room.UpdateChatEvent(roomid: request.roomid, eventid: request.eventid), withData: request.toDictionary(), requestType: .PUT, expectation: Event.self, append: false) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    public func messageIsReactedTo(_ userid: String, event: Event?) -> Bool {
        guard event != nil else { return false }
        
        if let event = event {
            if !event.reactions.isEmpty {
                if event.reactions.contains(where: { $0.users.contains(where: { $0.userid == userid }) }) {
                    return true
                }
            }
        }
        
        return false
    }
    
    public func messageIsReported(_ userid: String, event: Event?) -> Bool {
        guard let reports = event?.reports else { return false }
        return reports.contains(where: { $0.userid == userid })
    }
}


// MARK: - Moderation
extension ChatClient {
    public func approveEvent(_ request: ModerationRequest.ApproveEvent, completionHandler: @escaping Completion<Event>) {
        makeRequest(URLPath.Mod.Approve(eventid: request.eventid), withData: request.toDictionary(), requestType: .POST, expectation: Event.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }

    public func rejectEvent(_ request: ModerationRequest.RejectEvent, completionHandler: @escaping Completion<Event>) {
        makeRequest(URLPath.Mod.Reject(eventid: request.eventid), withData: request.toDictionary(), requestType: .POST, expectation: Event.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    public func listMessagesInModerationQueue(_ request: ModerationRequest.listMessagesInModerationQueue, completionHandler: @escaping Completion<ListMessagesNeedingModerationResponse>) {
        makeRequest(URLPath.Mod.List(), withData: request.toDictionary(), requestType: .GET, expectation: ListMessagesNeedingModerationResponse.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
}

// MARK: - Event Subscription
extension ChatClient {
    public func startListeningToChatUpdates(limit: Int? = nil, completionHandler: @escaping Completion<[Event]>) {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { _ in
            let request = ChatRequest.GetMoreUpdates()
            request.roomid = self.lastroomid
            request.cursor = self.lastcursor
            request.limit = limit
            
            self.getMoreUpdates(request) { [weak self] (code, message, kind, response) in
                // Invalid timer should disregard further update results
                guard
                    let self = self,
                    let timer = self.timer,
                    timer.isValid
                else {
                    return
                }
                
                if let response = response {
                    var emittableEvents = [Event]()
                    
                    if let cursor = response.cursor {
                        if !cursor.isEmpty {
                            self.lastcursor = cursor
                        }
                    }
                    
                    emittableEvents = response.events
                    
                    completionHandler(code, message, kind, emittableEvents)
                }
            }
        })
    }
    
    public func stopListeningToChatUpdates() {
        timer?.invalidate()
    }
}
