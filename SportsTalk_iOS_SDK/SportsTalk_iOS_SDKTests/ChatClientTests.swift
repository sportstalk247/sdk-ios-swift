import XCTest
import SportsTalk_iOS_SDK

class ChatClientTests: XCTestCase {
    let client = ChatClient(config: ClientConfig(appId: Config.appId, authToken: Config.authToken, endpoint: Config.url))
    
    lazy var dummyUser: User? = {
        let user = User()
        user.userid = "9940A8C9-2332-4824-B628-48390F367D29"
        user.handle = "GeorgeWASHING"
        user.banned = true
        user.displayname = "George Washing"
        user.pictureurl = "http://www.thepresidentshalloffame.com/media/reviews/photos/original/a9/c7/a6/44-1-george-washington-18-1549729902.jpg"
        user.profileurl = "http://www.thepresidentshalloffame.com/1-george-washington"
        return user
    }()
    
    var dummyRoom: ChatRoom? { didSet { print("Room saved: \(String(describing: self.dummyRoom?.id))") }  }
    var dummyEvent: Event? { didSet { print("Event saved: \(String(describing: self.dummyEvent?.id))") }  }
    var dummyEventNeedingModeration: Event? { didSet { print("Event saved: \(String(describing: self.dummyEventNeedingModeration?.id))") }  }
    
    override func setUp() {
        SportsTalkSDK.shared.debugMode = true
    }
}

extension ChatClientTests {
    func test_ChatRoomsServices_CreateRoomPostmoderated() {
        let request = ChatRoomsServices.CreateRoomPostmoderated()
        request.name = "Test Room Post Moderated 3"
        request.customid = "some-custom-id"
        request.description = "Chat Room Newly Created"
        request.enableactions = true
        request.enableenterandexit = false
        request.roomisopen = true

        let expectation = self.expectation(description: Constants.Expectation_Description)
        var receivedCode: Int?
        var receivedRoom: ChatRoom?
        
        client.createRoomPostModerated(request) { (code, message, _, room) in
            print(message ?? "")
            receivedCode = code
            receivedRoom = room
            self.dummyRoom = room
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(receivedRoom != nil)
    }

    func test_ChatRoomsServices_CreateRoomPremoderated() {
        let request = ChatRoomsServices.CreateRoomPremoderated()
        request.name = "Test Room Pre Moderated 1"
        request.description = "Chat Room Newly Created (Premoderated)"
        request.enableactions = true
        request.enableenterandexit = false
        request.roomisopen = true
        request.maxreports = 0

        let expectation = self.expectation(description: Constants.Expectation_Description)
        var receivedCode: Int?
        var receivedRoom: ChatRoom?
        
        client.createRoomPreModerated(request) { (code, message, _, room) in
            print(message ?? "")
            receivedCode = code
            receivedRoom = room
            self.dummyRoom = room
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(receivedRoom != nil)
    }

    func test_ChatRoomsServices_GetRoomDetails() {
        test_ChatRoomsServices_CreateRoomPostmoderated()
        let request = ChatRoomsServices.GetRoomDetails()
        request.roomid = dummyRoom?.id

        let expectation = self.expectation(description: Constants.Expectation_Description)
        var receivedCode: Int?
        var receivedRoom: ChatRoom?

        client.getRoomDetails(request) { (code, message, _, room) in
            print(message ?? "")
            print("found \(String(describing: room?.name))")
            receivedCode = code
            receivedRoom = room
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(receivedRoom != nil)
    }

    func test_ChatRoomsServices_DeleteRoom() {
        test_ChatRoomsServices_CreateRoomPostmoderated()
        let request = ChatRoomsServices.DeleteRoom()
        request.roomid = dummyRoom?.id

        let expectation = self.expectation(description: Constants.Expectation_Description)
        var receivedCode: Int?

        client.deleteRoom(request) { (code, message, _, response) in
            print(message ?? "")
            print("\(String(describing: response?.room?.name)) deleted")
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }

    func test_ChatRoomsServices_UpdateRoom() {
        test_ChatRoomsServices_CreateRoomPostmoderated()
        let request = ChatRoomsServices.UpdateRoom()
        request.name = "Updated Room"
        request.description = "This room has recently been updated"
        request.roomisopen = true
        request.roomid = dummyRoom?.id

        let expectation = self.expectation(description: Constants.Expectation_Description)
        var receivedCode: Int?
        var receivedRoom: ChatRoom?

        client.updateRoom(request) { (code, message, _, room) in
            print(message ?? "")
            print(String(describing: room?.description))
            receivedCode = code
            receivedRoom = room
            self.dummyRoom = room
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(receivedRoom != nil)
    }

    func test_ChatRoomsServices_UpdateRoomCloseARoom() {
        test_ChatRoomsServices_CreateRoomPostmoderated()
        let request = ChatRoomsServices.UpdateRoomCloseARoom()
        request.roomisopen = false
        request.roomid = dummyRoom?.id

        let expectation = self.expectation(description: Constants.Expectation_Description)
        var receivedCode: Int?
        var receivedRoom: ChatRoom?

        client.updateCloseRoom(request) { (code, message, _, room) in
            print(message ?? "")
            print(String(describing: room?.open))
            receivedCode = code
            receivedRoom = room
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)

        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(receivedRoom?.open == false)
    }

    func test_ChatRoomsServices_ListRooms() {
        let request = ChatRoomsServices.ListRooms()

        let expectation = self.expectation(description: Constants.Expectation_Description)
        var receivedCode: Int?
        var receivedRoom: [ChatRoom]?
        
        client.listRooms(request) { (code, message, _, response) in
            print(message ?? "")
            print("found \(String(describing: response?.rooms.count)) rooms")
            receivedCode = code
            receivedRoom = response?.rooms
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(receivedRoom != nil)
    }
    
    func test_ChatRoomsServices_ListRoomParticipants()
    {
        test_ChatRoomsServices_JoinRoomAuthenticatedUser()
        let request = ChatRoomsServices.ListRoomParticipants()
        request.roomid = dummyRoom?.id

        let expectation = self.expectation(description: Constants.Expectation_Description)
        var receivedCode: Int?

        client.listRoomParticipants(request) { (code, message, kind, response) in
            print(message ?? "")
            print("found \(String(describing: response?.rooms.count)) rooms")
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }

    func test_ChatRoomsServices_JoinRoomAuthenticatedUser() {
        if dummyUser ==  nil {
            self.createUpdateUser()
        }
        
        if dummyRoom == nil {
            test_ChatRoomsServices_CreateRoomPostmoderated()
        }
        
        let request = ChatRoomsServices.JoinRoomAuthenticatedUser()
        request.userid = dummyUser?.userid
        request.displayname = dummyUser?.displayname
        request.roomid = dummyRoom?.id

        let expectation = self.expectation(description: Constants.Expectation_Description)
        var receivedCode: Int?
        var receivedUser: User?
        
        client.joinRoomAuthenticated(request) { (code, message, _, response) in
            print(message ?? "")
            receivedCode = code
            receivedUser = response?.user
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)

        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(receivedUser != nil)
    }
    
    func test_ChatRoomsServices_JoinRoomByCustomId() {
        if dummyUser ==  nil {
            self.createUpdateUser()
        }
        
        if dummyRoom == nil {
            test_ChatRoomsServices_CreateRoomPostmoderated()
        }
        
        let request = ChatRoomsServices.JoinRoomByCustomId()
        request.userid = dummyUser?.userid
        request.displayname = dummyUser?.displayname
        request.customid = dummyRoom?.customid

        let expectation = self.expectation(description: Constants.Expectation_Description)
        var receivedCode: Int?
        var receivedUser: User?
        
        client.joinRoomByCustomId(request) { (code, message, _, response) in
            print(message ?? "")
            receivedCode = code
            receivedUser = response?.user
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)

        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(receivedUser != nil)
    }


    func test_ChatRoomsServices_JoinRoomAnonymousUser() {
        test_ChatRoomsServices_CreateRoomPostmoderated()
        let request = ChatRoomsServices.JoinRoomAnonymousUser()
        request.roomid = dummyRoom?.id

        let expectation = self.expectation(description: Constants.Expectation_Description)
        var receivedCode: Int?
        
        client.joinRoomAnonymous(request) { (code, message, _, response) in
            print(message ?? "")
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }


    func test_ChatRoomsServices_ExitRoom() {
        if dummyUser == nil {
            self.createUpdateUser()
        }
        test_ChatRoomsServices_JoinRoomAuthenticatedUser()

        let request = ChatRoomsServices.ExitRoom()
        request.roomId = dummyRoom?.id
        request.userid = dummyUser?.userid

        let expectation = self.expectation(description: Constants.Expectation_Description)
        var receivedCode: Int?

        client.exitRoom(request) { (code, message, _, response) in
            print(message ?? "")
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }

    func test_ChatRoomsServices_GetUpdates() {
        test_ChatRoomsServices_ExecuteChatCommand()
        let request = ChatRoomsServices.GetUpdates()
        request.roomId = dummyRoom?.id

        let expectation = self.expectation(description: Constants.Expectation_Description)
        var receivedCode: Int?
        
        client.getUpdates(request) { (code, message, _, response) in
            print(message ?? "")
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }

    func test_ChatRoomsServices_GetUpdatesMore() {
        test_ChatRoomsServices_ExecuteChatCommand()
        let request = ChatRoomsServices.GetUpdatesMore()
        request.roomIdOrLabel = dummyRoom?.id
        request.eventid = dummyEvent?.id

        let expectation = self.expectation(description: Constants.Expectation_Description)
        var receivedCode: Int?
        
        client.getUpdatesMore(request) { (code, message, _, response) in
            print(message ?? "")
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }

     func test_ChatRoomsServices_ExecuteChatCommand() {
        test_ChatRoomsServices_JoinRoomAuthenticatedUser()
        let request = ChatRoomsServices.ExecuteChatCommand()
        request.roomId = dummyRoom?.id
        request.command = "Hello New Command"
        request.userid = dummyUser?.userid

        let expectation = self.expectation(description: Constants.Expectation_Description)
        var receivedCode: Int?
    
        client.executeChatCommand(request) { (code, message, _, response) in
            print(message ?? "")
            receivedCode = code
            self.dummyEvent = response?.speech
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }

    func test_ChatRoomsServices_ListMessagesByUsers() {
        test_ChatRoomsServices_ExecuteChatCommand()
        let request = ChatRoomsServices.ListMessagesByUser()
        request.limit = "4"
        request.roomid = dummyRoom?.id
        request.userId = dummyUser?.userid

        let expectation = self.expectation(description: Constants.Expectation_Description)
        var receivedCode: Int?

        client.listMessagesByUser(request) { (code, message, _, response) in
            print(message ?? "")
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }

    func test_ChatRoomsServices_ReportMessage() {
        test_ChatRoomsServices_CreateRoomPremoderated()
        test_ChatRoomsServices_ExecuteChatCommand()
        let request = ChatRoomsServices.ReportMessage()
        request.chat_room_newest_speech_id = dummyEvent?.id
        request.chatRoomId = dummyRoom?.id
        request.userid = dummyUser?.userid

        let expectation = self.expectation(description: Constants.Expectation_Description)
        var receivedCode: Int?

        client.reportMessage(request) { (code, message, _, event) in
            print(message ?? "")
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }

    func test_ChatRoomsServices_ReactToAMessage() {
        test_ChatRoomsServices_ExecuteChatCommand()
        let request = ChatRoomsServices.ReactToAMessageLike()
        request.roomId = dummyRoom?.id
        request.roomNewestEventId = dummyEvent?.id
        request.userid = dummyUser?.userid
        request.reaction = "like"
        request.reacted = "true"

        let expectation = self.expectation(description: Constants.Expectation_Description)
        var receivedCode: Int?
        
        client.reactToAMessage(request) { (code, message, _, event) in
            print(message ?? "")
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }
}
// MARK: - Moderation
extension ChatClientTests {
    func test_ModerationServices_ApproveMessage() {
        test_ModerationServices_ListMessagesNeedingModeration()
        let request = ModerationServices.ApproveMessage()
        request.chatMessageId = dummyEventNeedingModeration?.id
        request.chatRoomId = dummyRoom?.id

        let expectation = self.expectation(description: Constants.Expectation_Description)
        var receivedCode: Int?
        
        client.approveMessage(request) { (code, message, _, event) in
            print(message ?? "")
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }
    
    func test_ModerationServices_ListMessagesNeedingModeration() {
        test_ChatRoomsServices_ReportMessage()
        let request = ModerationServices.ListMessagesNeedingModeration()
        
        let expectation = self.expectation(description: Constants.Expectation_Description)
        var receivedCode: Int?
        
        client.listMessagesNeedingModeration(request) { (code, message, _, response) in
            print(message ?? "")
            receivedCode = code
            self.dummyEventNeedingModeration = response?.events.first
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(dummyEventNeedingModeration != nil)
    }
}

// MARK: - EventSubscription
extension ChatClientTests {
    func test_EventSubscription() {
        test_ChatRoomsServices_CreateRoomPostmoderated()
        
        let expectation = self.expectation(description: Constants.Expectation_Description)
        var receivedCode: Int?
        
        guard let roomid = dummyRoom?.id else {
            expectation.fulfill()
            return
        }
        
        self.client.startEventUpdates(from: roomid) { (code, message, _, event) in
            print("------------")
            print(code == 200 ? "pulse success" : "pulse failed")
            print((event?.count ?? 0) > 0 ? "received \(event?.count) event" : "No new events")
            print("------------")
            receivedCode = code
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(Config.TIMEOUT) - 1)) {
            self.client.stopEventUpdates()
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }
}

// MARK: - Convenience
extension ChatClientTests {
    private func createUpdateUser() {
        let client = UserClient(config: self.client.config)
        let request = UsersServices.CreateUpdateUser()
        request.userid = UUID().uuidString
        request.handle = "Sam"
        request.displayname = "Sam"
        request.pictureurl = URL(string: dummyUser?.pictureurl ?? "")
        request.profileurl = URL(string: dummyUser?.profileurl ?? "")
        
        client.createOrUpdateUser(request) { (code, message, kind, user) in
            self.dummyUser = user
        }
    }
    
    private func getDateTimeString() -> String{
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let date = Date()
        return dateFormatter.string(from: date)
    }
}
