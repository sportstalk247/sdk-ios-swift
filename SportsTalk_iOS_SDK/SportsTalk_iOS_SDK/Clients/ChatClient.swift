//
//  ChatClient.swift
//  SportsTalk_iOS_SDK
//
//  Created by Angelo Lesano on 5/17/20.
//  Copyright © 2020 krishna41. All rights reserved.
//

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
    func joinRoomAnonymous(_ request: ChatRoomsServices.JoinRoomAnonymousUser, completionHandler: @escaping Completion<JoinChatRoomResponse>)
    func exitRoom(_ request: ChatRoomsServices.ExitRoom, completionHandler: @escaping Completion<ExitChatRoomResponse>)
    func getUpdates(_ request: ChatRoomsServices.GetUpdates, completionHandler: @escaping Completion<GetUpdatesResponse>)
    func getUpdatesMore(_ request: ChatRoomsServices.GetUpdatesMore, completionHandler: @escaping Completion<GetUpdatesResponse>)
    func executeChatCommand(_ request: ChatRoomsServices.ExecuteChatCommand, completionHandler: @escaping Completion<ExecuteChatCommandResponse>)
//    func chatRoomsServices(_ request: ChatRoomsServices.ExecuteDanceAction, completionHandler: @escaping CompletionHandler)
//    func chatRoomsServices(_ request: ChatRoomsServices.ReplyToAMessage, completionHandler: @escaping CompletionHandler)
    func listMessagesByUser(_ request: ChatRoomsServices.ListMessagesByUser, completionHandler: @escaping Completion<ListMessagesByUser>)
//    func chatRoomsServices(_ request: ChatRoomsServices.RemoveMessage, completionHandler: @escaping CompletionHandler)
//    func chatRoomsServices(_ request: ChatRoomsServices.PurgeUserMessages, completionHandler: @escaping CompletionHandler)
    func reportMessage(_ request: ChatRoomsServices.ReportMessage, completionHandler: @escaping Completion<Event>)
    func reactToAMessage(_ request: ChatRoomsServices.ReactToAMessageLike, completionHandler: @escaping Completion<Event>)
//    func chatRoomsServices(_ request: ChatRoomsServices.ExecuteAdminCommand, completionHandler: @escaping CompletionHandler)
//    func chatRoomsServices(_ request: ChatRoomsServices.DeleteAllEventsInRoom, completionHandler: @escaping CompletionHandler)
    
    // Moderation
    func approveMessage(_ request: ModerationServices.ApproveMessage, completionHandler: @escaping Completion<Event>)
    func listMessagesNeedingModeration(_ request: ModerationServices.ListMessagesNeedingModeration, completionHandler: @escaping Completion<ListMessagesNeedingModerationResponse>)

//    func moderationServices(_ request: ModerationServices.ApproveCommentInQueue, completionHandler: @escaping CompletionHandler)
//    func moderationServices(_ request: ModerationServices.RejectCommentInQueue, completionHandler: @escaping CompletionHandler)
//    func moderationServices(_ request: ModerationServices.ListCommentsInModerationQueue, completionHandler: @escaping CompletionHandler)
    
}

public class ChatClient: NetworkService, ChatClientProtocol {
    public override init(config: ClientConfig) {
        super.init(config: config)
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

//    public func chatRoomsServices(_ request: ChatRoomsServices.ExecuteDanceAction , completionHandler: @escaping CompletionHandler)
//    {
//        makeRequest("\(ServiceKeys.chat)\(request.roomId ?? emptyString)/command", withData: request.toDictionary(), requestType: .POST) { (response) in
//            completionHandler(response)
//        }
//    }
//
//    public func chatRoomsServices(_ request: ChatRoomsServices.ReplyToAMessage , completionHandler: @escaping CompletionHandler)
//    {
//        makeRequest("\(ServiceKeys.chat)\(request.roomId ?? emptyString)/command", withData: request.toDictionary(), requestType: .POST) { (response) in
//            completionHandler(response)
//        }
//    }
//
    public func listMessagesByUser(_ request: ChatRoomsServices.ListMessagesByUser, completionHandler: @escaping Completion<ListMessagesByUser>) {
        makeRequest("\(ServiceKeys.chat)\(request.roomid ?? emptyString)/messagesbyuser/\(request.userId ?? emptyString)", withData: request.toDictionary(), requestType: .GET, expectation: ListMessagesByUser.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
//
//    public func chatRoomsServices(_ request: ChatRoomsServices.RemoveMessage, completionHandler: @escaping CompletionHandler) {
//        makeRequest("\(ServiceKeys.chat)\(request.chatRoomId ?? emptyString)/events/\(request.chatMessageId ?? emptyString)", withData: request.toDictionary(), requestType: .DELETE) { (response) in
//            completionHandler(response)
//        }
//    }

//    public func chatRoomsServices(_ request: ChatRoomsServices.PurgeUserMessages, completionHandler: @escaping CompletionHandler) {
//        makeRequest("\(ServiceKeys.chat)\(request.chatroomid ?? emptyString)/command", withData: request.toDictionary(), requestType: .POST) { (response) in
//            completionHandler(response)
//        }
//    }
//
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
//
//    public func chatRoomsServices(_ request: ChatRoomsServices.ExecuteAdminCommand , completionHandler: @escaping CompletionHandler)
//    {
//        makeRequest("\(ServiceKeys.chat)\(request.roomId ?? emptyString)/command", withData: request.toDictionary(), requestType: .POST) { (response) in
//            completionHandler(response)
//        }
//    }
//
//    public func chatRoomsServices(_ request: ChatRoomsServices.DeleteAllEventsInRoom, completionHandler: @escaping CompletionHandler) {
//        makeRequest("\(ServiceKeys.chat)\(request.chatroomid ?? emptyString)/command", withData: request.toDictionary(), requestType: .POST) { (response) in
//            completionHandler(response)
//        }
//    }
    
//    struct rx { /* Add reactive funcs here */ }
}


// Moderation
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
//        struct rx { /* Add reactive funcs here */ }
    
}
