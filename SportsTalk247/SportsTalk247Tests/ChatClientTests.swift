import XCTest
import SportsTalk247

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
    
    lazy var otherUser: User? = {
        let user = User()
        user.userid = "9940A8C9-2332-4824-B628-48390F367D30"
        user.handle = "JohnWICK"
        user.banned = true
        user.displayname = "John Wick"
        user.pictureurl = ""
        user.profileurl = ""
        return user
    }()

    var dummyRoom: ChatRoom? { didSet { print("Room saved: \(String(describing: self.dummyRoom?.id))") }  }
    var dummyEvent: Event? { didSet { print("Event saved: \(String(describing: self.dummyEvent?.id))") }  }
    var dummyEventNeedingModeration: Event? { didSet { print("Event saved: \(String(describing: self.dummyEventNeedingModeration?.id))") }  }
    var dummyEventList: [Event]? { didSet { print("Event list saved: \(dummyEventList?.count ?? 0)") } }
    
    override func setUpWithError() throws {
        SportsTalkSDK.shared.debugMode = true
        createUpdateUser()
    }
}

extension ChatClientTests {
    func test_ChatRoomsServices_CreateRoom() {
        let request = ChatRequest.CreateRoom()
        request.name = "Test Room Post Moderated 3"
        request.customid = "some-custom-id"
        request.description = "Chat Room Newly Created"
        request.moderation = "post"
        request.enableactions = true
        request.enableenterandexit = false
        request.roomisopen = true
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        var receivedRoom: ChatRoom?
        
        client.createRoom(request) { (code, message, _, room) in
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
    
    func test_ChatRoomsServices_CreateRoomPostmoderated() {
        let request = ChatRequest.CreateRoom()
        request.name = "Test Room Post Moderated 3"
        request.customid = "chathubcard.th.บัตรบรรณาธิการซึ่งจะปรากฏในวันอาทิตย์"
        request.description = "Chat Room Newly Created"
        request.enableactions = true
        request.moderation = "post"
        request.enableenterandexit = false
        request.roomisopen = true

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        var receivedRoom: ChatRoom?
        
        client.createRoom(request) { (code, message, _, room) in
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
        let request = ChatRequest.CreateRoom()
        request.name = "Test Room Pre Moderated 1"
        request.description = "Chat Room Newly Created (Premoderated)"
        request.enableactions = true
        request.enableenterandexit = false
        request.moderation = "pre"
        request.roomisopen = true
        request.maxreports = 0

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        var receivedRoom: ChatRoom?
        
        client.createRoom(request) { (code, message, _, room) in
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
        if dummyRoom == nil {
            test_ChatRoomsServices_CreateRoomPostmoderated()
        }
        
        let request = ChatRequest.GetRoomDetails()
        request.roomid = dummyRoom?.id

        let expectation = self.expectation(description: Constants.expectation_description(#function))
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

    func test_ChatRoomsServices_GetRoomExtendedDetails() {
        if dummyRoom == nil {
            test_ChatRoomsServices_CreateRoomPostmoderated()
        }
        
        let request = ChatRequest.GetRoomExtendedDetails()
        request.roomid = dummyRoom?.id
        request.entity = [.room, .lastmessagetime, .numberofparticipants, .room, .room, .room]
        // request.entity shouldn't have duplicates.

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        var receivedRoom: ChatRoom?

        client.getRoomExtendedDetails(request) { (code, message, _, response) in
            print(message ?? "")
//            print("found \(String(describing: details?.filter { $0.id == dummyRoom.id }))")
            receivedCode = code
            receivedRoom = response?.details?.first
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(receivedRoom != nil)
    }

    
    func test_ChatRoomsServices_GetRoomDetailsByCustomId() {
        test_ChatRoomsServices_CreateRoomPostmoderated()
        let request = ChatRequest.GetRoomDetailsByCustomId()
        request.customid = dummyRoom?.customid

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        var receivedRoom: ChatRoom?

        client.getRoomDetailsByCustomId(request) { (code, message, _, room) in
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
        if dummyRoom == nil {
            test_ChatRoomsServices_CreateRoomPostmoderated()
        }
        
        let request = ChatRequest.DeleteRoom()
        request.roomid = dummyRoom?.id

        let expectation = self.expectation(description: Constants.expectation_description(#function))
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
        let request = ChatRequest.UpdateRoom()
        request.name = "Updated Room"
        request.description = "This room has recently been updated"
        request.customid = "new-custom-id-" + String(Int.random(in: 0..<1995))
        request.roomisopen = true
        request.roomid = dummyRoom?.id

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        var receivedRoom: ChatRoom?

        client.updateRoom(request) { (code, message, _, room) in
            print(message ?? "")
            print(String(describing: room?.description))
            print(String(describing: room?.customid))
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
        let request = ChatRequest.UpdateRoomCloseARoom()
        request.roomisopen = false
        request.roomid = dummyRoom?.id

        let expectation = self.expectation(description: Constants.expectation_description(#function))
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
        let request = ChatRequest.ListRooms()

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        var receivedRoom: [ChatRoom]?
        
        client.listRooms(request) { (code, message, _, response) in
            print(message ?? "")
            print("found \(String(describing: response?.rooms.count)) rooms")
            if response?.rooms.count ?? 0 > 0 {
                self.dummyRoom = response?.rooms.first
            }
            receivedCode = code
            receivedRoom = response?.rooms
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(receivedRoom != nil)
    }
        
    func test_ChatRoomsServices_ListRoomParticipants() {
        if dummyRoom == nil {
            test_ChatRoomsServices_JoinRoomAuthenticatedUser()
        }
        
        let request = ChatRequest.ListRoomParticipants()
        request.roomid = dummyRoom?.id

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?

        client.listRoomParticipants(request) { (code, message, kind, response) in
            print(message ?? "")
            print("found \(String(describing: response?.participants.count)) participant")
            
            print(response?.participants.first?.user?.displayname ?? "")
            
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }
    
    func test_ChatRoomsServices_ListEventHistory() {
        test_ChatRoomsServices_JoinRoomAuthenticatedUser()
        let request = ChatRequest.ListEventHistory()
        request.roomid = dummyRoom?.id
        request.limit = 10

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?

        client.listEventHistory(request) { (code, message, kind, response) in
            print(message ?? "")
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }
    
    func test_ChatRoomsServices_ListPreviousEvents() {
        test_ChatRoomsServices_JoinRoomAuthenticatedUser()
        let request = ChatRequest.ListPreviousEvents()
        request.roomid = dummyRoom?.id

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?

        client.listPreviousEvents(request) { (code, message, kind, response) in
            print(message ?? "")
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }
    
    func test_ChatRoomsServices_ListEventsByType() {
        test_ChatRoomsServices_JoinRoomAuthenticatedUser()
        let request = ChatRequest.ListEventByType()
        request.roomid = dummyRoom?.id
        request.eventtype = .custom
        request.customtype = "goal"
        request.limit = 1

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?

        client.listEventByType(request) { (code, message, kind, response) in
            print(message ?? "")
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }
    
    func test_ChatRoomsServices_ListEventsByTime() {
        test_ChatRoomsServices_JoinRoomAuthenticatedUser()
        let request = ChatRequest.ListEventByTimestamp()
        request.roomid = dummyRoom?.id
        request.timestamp = 123123123123
        request.limitolder = 10
        request.limitnewer = 10

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?

        client.listEventByTimestamp(request) { (code, message, kind, response) in
            print(message ?? "")
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }

    
    func test_ChatRoomsServices_JoinRoom() {
        if dummyUser ==  nil {
            self.createUpdateUser()
        }
        
        if dummyRoom == nil {
            test_ChatRoomsServices_CreateRoomPostmoderated()
        }
        
        let request = ChatRequest.JoinRoom()
        request.userid = dummyUser?.userid
        request.displayname = dummyUser?.displayname
        request.roomid = dummyRoom?.id
        request.limit = 150

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        var receivedUser: User?
        
        client.joinRoom(request) { (code, message, _, response) in
            print(message ?? "")
            receivedCode = code
            receivedUser = response?.user
            self.dummyRoom = response?.room
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)

        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(receivedUser != nil)
    }

    func test_ChatRoomsServices_JoinRoomAuthenticatedUser() {
        if dummyUser ==  nil {
            self.createUpdateUser()
        }
        
        if dummyRoom == nil {
            test_ChatRoomsServices_CreateRoomPostmoderated()
        }
        
        let request = ChatRequest.JoinRoom()
        request.userid = dummyUser?.userid
        request.displayname = dummyUser?.displayname
        request.roomid = dummyRoom?.id

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        var receivedUser: User?
        
        client.joinRoom(request) { (code, message, _, response) in
            print(message ?? "")
            receivedCode = code
            receivedUser = response?.user
            self.dummyRoom = response?.room
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
        
        let request = ChatRequest.JoinRoomByCustomId()
        request.userid = dummyUser?.userid
        request.displayname = dummyUser?.displayname
        request.customid = "chathubcard.th.บัตรบรรณาธิการซึ่งจะปรากฏในวันอาทิตย์"

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        var receivedUser: User?
        
        client.joinRoomByCustomId(request) { (code, message, _, response) in
            print(message ?? "")
            receivedCode = code
            receivedUser = response?.user
            self.dummyRoom = response?.room
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)

        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(receivedUser != nil)
    }

    func test_ChatRoomsServices_ExitRoom() {
        if dummyUser == nil {
            self.createUpdateUser()
        }
        test_ChatRoomsServices_JoinRoomAuthenticatedUser()

        let request = ChatRequest.ExitRoom()
        request.roomid = dummyRoom?.id
        request.userid = dummyUser?.userid

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?

        client.exitRoom(request) { (code, message, _, response) in
            print(message ?? "")
            self.dummyRoom = nil
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }

    func test_ChatRoomsServices_GetUpdates() {
        test_ChatRoomsServices_ExecuteChatCommand()
        let request = ChatRequest.GetUpdates()
        request.roomid = dummyRoom?.id
        request.cursor = nil //Insert valid cursor
        request.limit = 20

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        
        client.getUpdates(request) { (code, message, _, response) in
            print(message ?? "")
            print(String(describing: response?.cursor))
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }
    
    func test_ChatRoomsServices_GetMoreUpdates() {
        test_ChatRoomsServices_ExecuteChatCommand()
        let request = ChatRequest.GetMoreUpdates()
        request.roomid = dummyRoom?.id
        request.limit = 3

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        
        client.getMoreUpdates(request) { (code, message, _, response) in
            print(message ?? "")
            print(String(describing: response?.cursor))
            print("\(String(describing: response?.events.count)) items returned")
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }


     func test_ChatRoomsServices_ExecuteChatCommand() {
        test_ChatRoomsServices_JoinRoom()

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
    
        do {
            let request = ChatRequest.ExecuteChatCommand()
            request.roomid = dummyRoom?.id
            request.command = randomMessage()
            request.userid = dummyUser?.userid
            request.eventtype = .speech
            
            try client.executeChatCommand(request, completionHandler: { (code, message, _, response) in
                print(message)
                receivedCode = code
                self.dummyEvent = response?.speech
                expectation.fulfill()
            })
        } catch {
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }
    
    func test_ChatRoomsServices_ExecuteChatCommandWithCustomId() {
        test_ChatRoomsServices_JoinRoomAuthenticatedUser()

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
    
        do {
            let request = ChatRequest.ExecuteChatCommand()
            request.roomid = dummyRoom?.id
            request.command = "Hello New Command"
            request.userid = dummyUser?.userid
            request.eventtype = .custom
            request.customtype = "test something"
            
            try client.executeChatCommand(request) { (code, message, _, response) in
                print(message ?? "")
                receivedCode = code
                self.dummyEvent = response?.speech
                expectation.fulfill()
            }
        } catch {
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }
    
    func test_ChatRoomsServices_SendQuotedReply() {
        if dummyUser == nil {
            createUpdateUser()
        }
        
        if dummyRoom == nil || dummyEvent == nil {
            test_ChatRoomsServices_ExecuteChatCommand()
        }
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
    
        do {
            let request = ChatRequest.SendQuotedReply()
            request.roomid = dummyRoom?.id
            request.eventid = dummyEvent?.id
            request.userid = dummyUser?.userid
            request.body = "SAY Hello SPORTSTALKSDK World!"
            
            try client.sendQuotedReply(request) { (code, message, _, response) in
                print(message ?? "")
                print("With Command: \(String(describing: request.body))")
                receivedCode = code
                self.dummyEvent = response
                expectation.fulfill()
            }
        } catch {
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }
    
    func test_ChatRoomsServices_SendThreadedReply() {
        if dummyUser == nil {
            createUpdateUser()
        }
        
        if dummyRoom == nil || dummyEvent == nil {
            test_ChatRoomsServices_ExecuteChatCommand()
        }
        
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
    
        do {
            let request = ChatRequest.SendThreadedReply()
            request.roomid = dummyRoom?.id
            request.eventid = dummyEvent?.id
            request.userid = dummyUser?.userid
            request.body = "SAY Hello SPORTSTALKSDK World!"
            
            try client.sendThreadedReply(request) { (code, message, _, response) in
                print(message ?? "")
                print("With Command: \(String(describing: request.body))")
                receivedCode = code
                self.dummyEvent = response
                expectation.fulfill()
            }
        } catch {
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }
    
    func test_ChatRoomsServices_PurgeMessages() {
        test_ChatRoomsServices_ExecuteChatCommand()
        
        let request = ChatRequest.PurgeUserMessages()
        request.password = "zola"
        request.roomid = dummyRoom?.id
        request.userid = dummyUser?.userid
        request.handle = dummyUser?.handle
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        
        client.purgeMessage(request) { (code, message, _, response) in
            print(message ?? "")
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }
    
    func test_ChatRoomsServices_FlagEventLogicallyDeleted() {
        test_ChatRoomsServices_JoinRoomAuthenticatedUser()
        test_ChatRoomsServices_ExecuteChatCommand()
        
        let request = ChatRequest.FlagEventLogicallyDeleted()
        request.roomid = dummyRoom?.id
        request.eventid = dummyEvent?.id
        request.userid = dummyUser?.userid
        request.deleted = true
        request.permanentifnoreplies = true
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        
        client.flagEventLogicallyDeleted(request) { (code, message, _, response) in
            print(message ?? "")
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertTrue(receivedCode == 200)

    }
    
    func test_ChatRoomsServices_PermanentlyDeleteEvent() {
        test_ChatRoomsServices_JoinRoomAuthenticatedUser()
        test_ChatRoomsServices_ExecuteChatCommand()
        
        let request = ChatRequest.PermanentlyDeleteEvent()
        request.eventid = dummyEvent?.id
        request.roomid = dummyEvent?.roomid
        request.userid = dummyEvent?.userid

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        
        client.permanentlyDeleteEvent(request) { (code, message, _, response) in
            print(message ?? "")
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }
    
    func test_ChatRoomsServices_DeleteAllEvents() {
        test_ChatRoomsServices_JoinRoom()
        
        let request = ChatRequest.DeleteAllEvents()
        request.password = "zola"
        request.userid = dummyUser?.userid
        request.roomid = dummyRoom?.id

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?

        client.deleteAllEvents(request) { (code, message, _, response) in
            print(message ?? "")
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }

    func test_ChatRoomsServices_ListMessagesByUsers() {
        // Error 500 when supplied with an invalid cursor
        
        test_ChatRoomsServices_ExecuteChatCommand()
        let request = ChatRequest.ListMessagesByUser()
        request.limit = 4
//        request.cursor = "samplecursor"
        request.roomid = dummyRoom?.id
        request.userId = dummyUser?.userid

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?

        client.listMessagesByUser(request) { (code, message, _, response) in
            print(message ?? "")
            self.dummyEventList = response?.events
            print(response?.events.first ?? "No events found")
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }

    func test_ChatRoomsServices_ReportMessage() {
        if dummyRoom == nil {
            test_ChatRoomsServices_CreateRoomPremoderated()
        }
        
        if dummyEvent == nil {
            test_ChatRoomsServices_ExecuteChatCommand()
        }
        
        let request = ChatRequest.ReportMessage()
        request.eventid = dummyEvent?.id
        request.roomid = dummyRoom?.id
        request.userid = dummyUser?.userid
        request.reporttype = .abuse

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?

        client.reportMessage(request) { (code, message, _, event) in
            print(message ?? "")
            receivedCode = code
            self.dummyEvent = event
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }

    func test_ChatRoomsServices_ReactToAMessage() {
        test_ChatRoomsServices_ExecuteChatCommand()
        let request = ChatRequest.ReactToEvent()
        request.roomid = dummyRoom?.id
        request.eventid = dummyEvent?.id
        request.userid = dummyUser?.userid
        request.reaction = "like"
        request.reacted = "true"

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        
        client.reactToEvent(request) { (code, message, _, event) in
            print(message ?? "")
            receivedCode = code
            self.dummyEvent = event
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }
    
    func test_ChatRoomsServices_ReportUserInRoom() {
        if dummyUser == nil {
            createUpdateUser()
        }
        
        if otherUser == nil {
            createUpdateOtherUser()
        }
        
        if dummyRoom == nil {
            test_ChatRoomsServices_CreateRoomPremoderated()
        }
        
        let request = ChatRequest.ReportUserInRoom()
        request.roomid = dummyRoom?.id
        request.userid = dummyUser?.userid
        request.reporteduserid = otherUser?.userid
        request.reporttype = .spam
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        
        client.reportUserInRoom(request) { (code, message, _, response) in
            print(message ?? "")
            print(response?.reportedusers.first?.added)
            receivedCode = code
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }
    
    func test_ChatRoomsServices_Bounce() {
        if dummyRoom == nil {
            test_ChatRoomsServices_CreateRoomPremoderated()
        }
        
        let request = ChatRequest.BounceUser()
        request.roomid = dummyRoom?.id
        request.userid = dummyUser?.userid
        request.bounce = true
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        
        client.bounceUser(request) { (code, message, _, response) in
            print(message ?? "")
            receivedCode = code
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }
    
    func test_ChatRoomsServices_Shadowban() {
        if dummyRoom == nil {
            test_ChatRoomsServices_CreateRoomPremoderated()
        }
        
        let request = ChatRequest.ShadowbanUser()
        request.roomid = dummyRoom?.id
        request.userid = dummyUser?.userid
        request.applyeffect = true
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        
        client.shadowbanUser(request) { (code, message, _, response) in
            print(message ?? "")
            receivedCode = code
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }
    
    func test_ChatRoomsServices_MuteUser() {
        if dummyRoom == nil {
            test_ChatRoomsServices_CreateRoomPremoderated()
        }
        
        let request = ChatRequest.MuteUser()
        request.roomid = dummyRoom?.id
        request.userid = dummyUser?.userid
        request.applyeffect = true
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        
        client.muteUser(request) { (code, message, _, response) in
            print(message ?? "")
            receivedCode = code
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }

    
    func test_ChatRoomsServices_SearchEvent() {
        test_ChatRoomsServices_ExecuteChatCommand()
        
        let request = ChatRequest.SearchEvent()
        request.fromhandle = "GeorgeWASHING"
        request.types = [.action, .reply, .speech]
        request.direction = .forward
        request.limit = 10

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        
        client.searchEventHistory(request) { (code, message, _, event) in
            print(message ?? "")
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }
    
    func test_ChatRoomsServices_UpdateChatEvent() {
        if dummyUser == nil {
            createUpdateUser()
        }
        
        test_ChatRoomsServices_JoinRoom()
        test_ChatRoomsServices_ExecuteChatCommand()
        
        let request = ChatRequest.UpdateChatEvent()
        request.roomid = dummyEvent?.roomid
        request.eventid = dummyEvent?.id
        request.userid = dummyEvent?.userid
        request.body = "New message editted by ChatRequest.UpdateChatEvent api"
        
        print("************")
        print("*  BEFORE  *")
        print("************")
        print("\"\(String(describing: dummyEvent?.body))\"")
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        
        client.updateChatEvent(request) { (code, message, _, event) in
            print("************")
            print("*  AFTER   *")
            print("************")
            print("\"\(String(describing: event?.body))\"")
            self.dummyEvent = event
            
            print(message ?? "")
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }
    
    func test_ChatRoomsServices_MessageReactedTo() {
        test_ChatRoomsServices_ReactToAMessage()
                
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        
        guard let userid = dummyUser?.userid, let event = dummyEvent else {
            expectation.fulfill()
            XCTAssertTrue(false)
            return
        }
        
        let reacted = client.messageIsReactedTo(userid, event: event)
        
        expectation.fulfill()
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssert(reacted)
    }
    
    func test_ChatRoomsServices_MessageReported() {
        test_ChatRoomsServices_ReportMessage()
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        
        guard let userid = dummyUser?.userid, let event = dummyEvent else {
            expectation.fulfill()
            XCTAssertTrue(false)
            return
        }
        
        let reported = client.messageIsReported(userid, event: event)
        
        expectation.fulfill()
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssert(reported)
    }
}

// MARK: - Moderation
extension ChatClientTests {
    func test_ModerationServices_ApproveEvent() {
        test_ModerationServices_ListMessagesInModerationQueue()
        let request = ModerationRequest.ApproveEvent()
        request.eventid = dummyEventNeedingModeration?.id
        request.roomid = dummyRoom?.id

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        
        client.approveEvent(request) { (code, message, _, event) in
            print(message ?? "")
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }
    
    func test_ModerationServices_RejectEvent() {
        test_ModerationServices_ListMessagesInModerationQueue()
        let request = ModerationRequest.RejectEvent()
        request.eventid = dummyEventNeedingModeration?.id
        request.roomid = dummyRoom?.id

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        
        client.rejectEvent(request) { (code, message, _, event) in
            print(message ?? "")
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }

    
    func test_ModerationServices_ListMessagesInModerationQueue() {
        test_ChatRoomsServices_ReportMessage()
        let request = ModerationRequest.listMessagesInModerationQueue()
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        
        client.listMessagesInModerationQueue(request) { (code, message, _, response) in
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
        var selectedRoom: ChatRoom?
        listRooms { rooms in
            selectedRoom = rooms?.first
        }
        
        if selectedRoom == nil {
            createRoom()
        }
        
        SportsTalkSDK.shared.debugMode = false
        
        func executeEvents() {
            let max = Int.random(in: 0...31)
            print("emmitting \(max) events")
            for _ in 0...max {
                test_ChatRoomsServices_ExecuteChatCommand()
            }
        }
        
        executeEvents()
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        
        client.startListeningToChatUpdates() { (code, message, _, event) in
            print("------------")
            print(code == 200 ? "pulse success" : "pulse failed")
            print((event?.count ?? 0) > 0 ? "received \(String(describing: event?.count)) event" : "No new events")
            print("------------")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10)) {
            self.client.stopListeningToChatUpdates()
            SportsTalkSDK.shared.debugMode = true
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT + 50, handler: nil)
    }
    
//    func test_KeepAlive() {
//        if dummyRoom == nil {
//            test_ChatRoomsServices_CreateRoomPremoderated()
//        }
//        
//        let request = ChatRequest.KeepAlive()
//        request.roomid = dummyRoom?.id
//        request.userid = dummyUser?.userid
//        
//        let expectation = self.expectation(description: Constants.expectation_description(#function))
//        var receivedCode: Int?
//        
//        client.keepAlive(request) { (code, message, _, response) in
//            print(message ?? "")
//            receivedCode = code
//            expectation.fulfill()
//        }
//        
//        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
//        XCTAssertTrue(receivedCode == 200)
//    }
}

// MARK: - Helpers
extension ChatClientTests {
    func test_ExecuteCommandThrottle() {
         // This test will always pass. The purpose of this test is to see if the date comparison works and is within the throttle's timeout parameter. However, the result tends to differ since it is affected by server response time.
         // Attach logs to ChatClient.throttle() -> Bool in order to check logic and timing.
        
        test_ChatRoomsServices_JoinRoom()
        
        let randomMessages = [
            "Hey.com", "Hello world", "Hello world", "Hello world", "Hello world", "Hello world", "Hello world" //addmore
        ]
        
        func executeCommand() {
            do {
                let request = ChatRequest.ExecuteChatCommand()
                request.roomid = dummyRoom?.id
                request.command = randomMessages[Int.random(in: 0..<randomMessages.count)]
//                request.command = "Hello New Command"
                request.userid = dummyUser?.userid
                request.eventtype = .speech
                
                print("command: \(request.command)")
            
                try client.executeChatCommand(request) { (code, message, _, response) in
                    self.dummyEvent = response?.speech
                }
            } catch {
                let error = error as! SDKError
                print(error.localizedDescription)
            }
        }
        
        SportsTalkSDK.shared.debugMode = false
        let limit = 15.0 // seconds
        var runtime = Double(0) // seconds
        
        let interval: Double = 0.5
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            print("\(runtime)/\(limit)")

            executeCommand()
            
            if runtime >= limit {
                timer.invalidate()
                expectation.fulfill()
            } else {
                runtime += interval
            }
        }
        
        timer.fire()
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
    }
}

// MARK: - Convenience
extension ChatClientTests {
    private func createUpdateUser() {
        let client = UserClient(config: self.client.config)
        let request = UserRequest.CreateUpdateUser()
        request.userid = "9940A8C9-2332-4824-B628-48390F367D29"
        request.handle = "GeorgeWASHING"
        request.displayname = "George Washing"
        request.pictureurl = URL(string: "http://www.thepresidentshalloffame.com/media/reviews/photos/original/a9/c7/a6/44-1-george-washington-18-1549729902.jpg")
        request.profileurl = URL(string: "http://www.thepresidentshalloffame.com/1-george-washington")
        
        client.createOrUpdateUser(request) { (code, message, kind, user) in
            self.dummyUser = user
        }
    }
    
    private func createUpdateOtherUser() {
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        
        let request = UserRequest.CreateUpdateUser()
        request.userid = "9940A8C9-2332-4824-B628-48390F367D30"
        request.handle = "JohnWICK"
        request.displayname = "John Wick"
        request.pictureurl = nil
        request.profileurl = nil
        
        let userclient = UserClient(config: ClientConfig(appId: Config.appId, authToken: Config.authToken, endpoint: Config.url))
        userclient.createOrUpdateUser(request) { (code, message, kind, user) in
            self.otherUser = user
            expectation.fulfill()
        }
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
    }
    
    private func listRooms(completion: @escaping (_ rooms: [ChatRoom]?) -> Void) {
        let request = ChatRequest.ListRooms()
        client.listRooms(request) { (code, message, _, response) in
            completion(response?.rooms)
        }
    }
    
    private func createRoom(completion: ((_ success: Bool) -> Void)? = nil) {
        let request = ChatRequest.CreateRoom()
        request.name = "Test Room Post Moderated 3"
        request.customid = "some-custom-id"
        request.description = "Chat Room Newly Created"
        request.enableactions = true
        request.moderation = "post"
        request.enableenterandexit = false
        request.roomisopen = true
        
        client.createRoom(request) { (code, message, _, room) in
            self.dummyRoom = room
            completion?(code == 200)
        }
    }
    
    private func getDateTimeString() -> String{
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let date = Date()
        return dateFormatter.string(from: date)
    }
    
    private func randomMessage() -> String {
        // Mi ultimo adios
        let phrases = [
            "I.",
            "Adiós, Patria adorada, región del sol querida",
            "Perla del mar de oriente, nuestro perdido Edén!",
            "A darte voy alegre la triste mustia vida,",
            "Y fuera más brillante, más fresca, más florida",
            "También por ti la diera, la diera por tu bien",
            "II.",
            "En campos de batalla, luchando con delirio,",
            "Otros te dan sus vidas sin dudas, sin pesar;",
            "El sitio nada importa, ciprés, laurel o lirio,",
            "Cadalso o campo abierto, combate o cruel martirio,",
            "Lo mismo es si lo piden la patria y el hogar.",
            "III.",
            "Yo muero cuando veo que el cielo se colora",
            "Y al fin anuncia el día tras lóbrego capuz;",
            "si grana necesitas para teñir tu aurora,",
            "Vierte la sangre mía, derrámala en buen hora",
            "Y dórela un reflejo de su naciente luz.",
            "IV",
            "Mis sueños cuando apenas muchacho adolescente,",
            "Mis sueños cuando joven ya lleno de vigor,",
            "Fueron el verte un día, joya del mar de oriente,",
            "Secos los negros ojos, alta la tersa frente,",
            "Sin ceño, sin arrugas, sin manchas de rubor",
            "V.",
            "Ensueño de mi vida, mi ardiente vivo anhelo,",
            "¡Salud te grita el alma que pronto va a partir!",
            "¡Salud! Ah, que es hermoso caer por darte vuelo,",
            "Morir por darte vida, morir bajo tu cielo,",
            "Y en tu encantada tierra la eternidad dormir.",
            "VI.",
            "Si sobre mi sepulcro vieres brotar un día",
            "Entre la espesa yerba sencilla, humilde flor,",
            "Acércala a tus labios y besa al alma mía,",
            "Y sienta yo en mi frente bajo la tumba fría,",
            "De tu ternura el soplo, de tu hálito el calor.",
            "VII.",
            "Deja a la luna verme con luz tranquila y suave,",
            "Deja que el alba envíe su resplandor fugaz,",
            "Deja gemir al viento con su murmullo grave,",
            "Y si desciende y posa sobre mi cruz un ave,",
            "Deja que el ave entone su cántico de paz.",
            "VIII.",
            "Deja que el sol, ardiendo, las lluvias evapore",
            "Y al cielo tornen puras, con mi clamor en pos;",
            "Deja que un ser amigo mi fin temprano llore",
            "Y en las serenas tardes cuando por mí alguien ore,",
            "¡Ora también, oh Patria, por mi descanso a Dios!",
            "IX.",
            "Ora por todos cuantos murieron sin ventura,",
            "Por cuantos padecieron tormentos sin igual,",
            "Por nuestras pobres madres que gimen su amargura;",
            "Por huérfanos y viudas, por presos en tortura",
            "Y ora por ti que veas tu redención final.",
            "X.",
            "Y cuando en noche oscura se envuelva el cementerio",
            "Y solos sólo muertos queden velando allí,",
            "No turbes su reposo, no turbes el misterio,",
            "Tal vez accordes oigas de cítara o salterio,",
            "Soy yo, querida Patria, yo que te canto a ti.",
            "XI.",
            "Y cuando ya mi tumba de todos olvidada",
            "No tenga cruz ni piedra que marquen su lugar,",
            "Deja que la are el hombre, la esparza con la azada,",
            "Y mis cenizas, antes que vuelvan a la nada,",
            "El polvo de tu alfombra que vayan a formar.",
            "XII.",
            "Entonces nada importa me pongas en olvido.",
            "Tu atmósfera, tu espacio, tus valles cruzaré.",
            "Vibrante y limpia nota seré para tu oído,",
            "Aroma, luz, colores, rumor, canto, gemido,",
            "Constante repitiendo la esencia de mi fe.",
            "XIII.",
            "Mi patria idolatrada, dolor de mis dolores,",
            "Querida Filipinas, oye el postrer adiós.",
            "Ahí te dejo todo, mis padres, mis amores.",
            "Voy donde no hay esclavos, verdugos ni opresores,",
            "Donde la fe no mata, donde el que reina es Dios.",
            "XIII.",
            "Adiós, padres y hermanos, trozos del alma mía,",
            "Amigos de la infancia en el perdido hogar,",
            "Dar gracias que descanso del fatigoso día;",
            "Adiós, dulce extranjera, mi amiga, mi alegría,",
            "Adiós, queridos seres, morir es descansar.",
        ]
        
        return phrases[Int.random(in: 0..<phrases.count)]
    }
}
