import XCTest
import SportsTalk247

struct Config {
    static let url = URL(string: "https://api.sportstalk247.com/api/v3")!
    static let appId = "63c16f13c3e89411881ba085"
    static let authToken = "cXSVhVOVYEewANzl7CuoWgw08gtq8FTUS4nxI_pHcQKg"
//    static let url = URL(string: "https://api.sportstalk247.com/api/v3")!
//    static let appId = "602e6fc50c916c171cb9a4e8"
//    static let authToken = "P1slSgD5l0yYBTWixyZ3_gGt69p5SOu0KEuGYLBXY8sw"
//    static let url = URL(string: "https://prod-api.sportstalk247.com/api/v3")!
//    static let appId = "5ffd115386c29223e4de754c"
//    static let authToken = "Cjh2_2VLhk2iyQUSEsfphAZkrrs6J-Vk2ELL7YzzwWJw"
    
//    static let url = URL(string: "http://ec2-35-178-80-243.eu-west-2.compute.amazonaws.com/api/v3")!
//    static let appId = "602e6fc50c916c171cb9a4e8"
//    static let authToken = "P1slSgD5l0yYBTWixyZ3_gGt69p5SOu0KEuGYLBXY8sw"
    
    static let TIMEOUT: Double = 30
}

struct Constants {
    static let commentConversationId = "Demo_Conversation"
    static let commentCommentId = "5e92b15d38a28d0b64536887"
    static let commentOwnerId = "brenn"
    static let customId = "/articles/2020-03-01/article1/something-very-important-happened"
    static let propertyId = "sportstalk247.com/apidemo"
    static let Expectation_Description = "Testing"
    
    static func expectation_description(_ function: String) -> String {
        return "\(function)"
    }
}

class UserClientTests: XCTestCase {
    let client = UserClient(config: ClientConfig(appId: Config.appId, authToken: Config.authToken, endpoint: Config.url))
    let chatClient = ChatClient(config: ClientConfig(appId: Config.appId, authToken: Config.authToken, endpoint: Config.url))
    
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
    
    var dummyRoom: ChatRoom? = nil
    var dummyChatEvent: Event? = nil
    var dummyThreadedReply: Event? = nil
    
    var dummyNotification: UserNotification? { didSet { print("UserNotification saved: \(dummyNotification?.id)") } }
        
    override func setUpWithError() throws {
        SportsTalkSDK.shared.debugMode = true
        createUpdateUser()
        createUpdateOtherUser()
    }
    
    override func tearDownWithError() throws {
        deleteUser(userid: dummyUser?.userid)
        deleteChatRoom(roomid: self.dummyRoom?.id)
        deleteNotification(userid: dummyUser?.userid, notificationid: dummyNotification?.id)
    }
}

extension UserClientTests {
    func test_UserServices_UpdateUser() {
        let request = UserRequest.CreateUpdateUser(
            userid: "9940A8C9-2332-48390F367D29",
            handle: "GeorgeWASHING",
            displayname: "George Washing",
            pictureurl: URL(string: "http://www.thepresidentshalloffame.com/media/reviews/photos/original/a9/c7/a6/44-1-george-washington-18-1549729902.jpg"),
            profileurl: URL(string: "http://www.thepresidentshalloffame.com/1-george-washington")
        )

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode = 0
        
        client.createOrUpdateUser(request) { (code, message, kind, user) in
            receivedCode = code ?? 0
            self.dummyUser = user
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }
        
    func test_UserServices_DeleteUser() {
        createUpdateOtherUser()
        
        let request = UserRequest.DeleteUser(
            userid: otherUser?.userid ?? ""
        )
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?

        client.deleteUser(request) { (code, message, _, response) in
            print(message ?? "")
            print("userId: \(String(describing: response?.user?.userid))")
            
            receivedCode = code
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)

        XCTAssertTrue(receivedCode == 200)
    }

    func test_UserServices_GetUserDetails() {
        if self.dummyUser == nil {
            self.createUpdateUser()
        }
        
        let request = UserRequest.GetUserDetails(
            userid: dummyUser?.userid ?? ""
        )

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedUser: User?
        var receivedCode: Int?
        
        client.getUserDetails(request) { (code, message, _, user) in
            print(message ?? "")
            print("user: \(String(describing: user?.displayname))")
            receivedUser = user
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(receivedUser != nil)
    }

    func test_UserServices_ListUsers() {
        createUpdateUser()
        createUpdateOtherUser()
        let request = UserRequest.ListUsers(
            limit: 5
        )

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedUsers: [User]?
        var receivedCode: Int?
        
        client.listUsers(request) { (code, message, _, response) in
            receivedCode = code
            receivedUsers = response?.users
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
        XCTAssertEqual(5, receivedUsers?.count)
    }

    func test_UserServices_BanUser() {
        if self.dummyUser == nil {
            createUpdateUser()
        }
        
        let request = UserRequest.SetBanStatus(
            userid: dummyUser?.userid ?? "",
            applyeffect: true
        )
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var banned: Bool?

        client.setBanStatus(request) { (code, message, _, user) in
            print(message ?? "")
            banned = user?.banned
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(banned == true)
    }
    
    func test_UserServices_GlobalPurge() {
        if self.dummyUser == nil {
            createUpdateUser()
        }
        
        let request = UserRequest.GloballyPurgeUserContent(
            userid: dummyUser?.userid ?? "",
            byuserid: dummyUser?.userid ?? ""
        )
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?

        client.globallyPurgeUserContent(request) { (code, message, _, user) in
            print(message ?? "")
            receivedCode = code
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
    }

    func test_UserServices_RestoreUser() {
        if self.dummyUser == nil {
            createUpdateUser()
        }
        
        let request = UserRequest.SetBanStatus(
            userid: dummyUser?.userid ?? "",
            applyeffect: false
        )
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var banned: Bool?

        client.setBanStatus(request) { (code, message, _, user) in
            print(message ?? "")
            banned = user?.banned
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(banned == false)
    }
    
    func test_UsersServices_SearchUser() {
        if self.otherUser == nil {
            createUpdateOtherUser()
        }
        
        let request = UserRequest.SearchUser()
        request.handle = "George"
        request.userid = "George"
        request.name = "George"
        request.limit = 5
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedUsers: [User]?
        var receivedCode: Int?
        
        client.searchUser(request) { (code, message, _, response) in
            print(message ?? "")
            
            print("found \(String(describing: response?.users.count))")
            response?.users.forEach { print( $0.displayname ?? "unknown name" ) }
            receivedUsers = response?.users
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssert(receivedUsers?.count != nil)
        XCTAssert(receivedCode == 200)
    }
    
    func test_UserServices_MuteUser() {
        if self.otherUser == nil {
            createUpdateOtherUser()
        }
        
        let request = UserRequest.MuteUser(
            userid: otherUser?.userid ?? "",
            applyeffect: true/*,
            expireseconds: 60*/
        )
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        
        client.muteUser(request) { (code, message, _, response) in
            print(message ?? "")
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssert(receivedCode == 200)
    }
    
    func test_UserServices_ReportUser() {
        if self.dummyUser == nil {
            createUpdateUser()
        }
        
        let request = UserRequest.ReportUser(
            userid: dummyUser?.userid ?? "",
            reporttype: .abuse
        )
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        
        client.reportUser(request) { (code, message, _, response) in
            print(message ?? "")
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssert(receivedCode == 200)
    }
    
    func test_UserServices_ShadowBan() {
        if self.dummyUser == nil {
            test_UserServices_UpdateUser()
        }
        
        let request = UserRequest.SetShadowBanStatus(
            userid: dummyUser!.userid!,
            applyeffect: !(dummyUser?.shadowbanned ?? false)/*,
            expireseconds: 60*/
        )
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var shadowbanned: Bool?
        var receivedCode: Int?
        
        client.setShadowBanStatus(request) { (code, message, _, response) in
            print(message ?? "")
            receivedCode = code
            shadowbanned = response?.shadowbanned
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssert(receivedCode == 200)
        XCTAssert(shadowbanned == !(dummyUser?.shadowbanned ?? false))
    }
    
    func test_UserServices_ListUserNotification() {
        if self.dummyUser == nil {
            test_UserServices_UpdateUser()
        }
        
        let request = UserRequest.ListUserNotifications(
            userid: self.dummyUser!.userid!
        )
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        
        client.listUserNotifications(request) { (code, message, _, response) in
            print(message ?? "")
            receivedCode = code
//            self.dummyNotification = response?.notifications?.filter{ ($0.isread ?? false) == false }.first
            self.dummyNotification = response?.notifications?.first
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssert(receivedCode == 200)
    }
    
    func test_UserServices_MarkAllNotificationAsRead() {
        if self.dummyUser == nil {
            test_UserServices_UpdateUser()
        }
        
        let request = UserRequest.MarkAllNotificationAsRead(
            userid: dummyUser!.userid ?? "",
            delete: false
        )
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        
        client.markAllNotificationAsRead(request) { (code, message, _, response) in
            print(message ?? "")
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssert(receivedCode == 200)
    }
    
    func test_UserServices_SetNotificationAsRead() {
        // Run ChatClientTest.test_chatRoomsServicesSendQuotedReply() if dummNotification is empty
        
        if self.dummyUser == nil {
            test_UserServices_UpdateUser()
        }
        
        if self.dummyRoom == nil {
            createTestChatRoom(name: "Notification As Read Room - (\(Int64(Date().timeIntervalSince1970)))", enableactions: true, moderation: "post", enableenterandexit: true, roomisopen: true)
        }
        
        if self.dummyChatEvent == nil,
           let userid = dummyUser?.userid,
           let roomid = dummyRoom?.id {
            testExecuteCommand(roomid: roomid, userid: userid, command: "Test Comment!")
        }
        
        if self.dummyThreadedReply == nil,
           let userid = dummyUser?.userid,
           let roomid = dummyRoom?.id,
           let replyto = dummyChatEvent?.id {
            testSendThreadedReply(roomid: roomid, userid: userid, replyto: replyto, command: "Test Threaded Reply!")
        }
        
        if self.dummyNotification == nil {
            listNotifications(
                userid: (dummyUser?.userid!)!,
                filternotificationtypes: [.chatreply],
                includeread: false,
                limit: 10
            )
        }
        
        guard let dummyNotification = self.dummyNotification else {
            XCTAssert(false)
            return
        }
        
        let request = UserRequest.SetUserNotificationAsRead(
            userid: dummyUser!.userid ?? "",
            notificationid: dummyNotification.id ?? "",
            read: true
        )
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        
        client.setUserNotificationAsRead(request) { (code, message, _, response) in
            print(message ?? "")
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssert(receivedCode == 200)
    }
    
    func test_UserServices_SetNotificationAsReadByEventId() {
        // Run ChatClientTest.test_chatRoomsServicesSendQuotedReply() if dummNotification is empty
        
        if self.dummyUser == nil {
            test_UserServices_UpdateUser()
        }
        
        if self.dummyRoom == nil {
            createTestChatRoom(name: "Notification As Read Room - (\(Int64(Date().timeIntervalSince1970)))", enableactions: true, moderation: "post", enableenterandexit: true, roomisopen: true)
        }
        
        if self.dummyChatEvent == nil,
           let userid = dummyUser?.userid,
           let roomid = dummyRoom?.id {
            testExecuteCommand(roomid: roomid, userid: userid, command: "Test Comment!")
        }
        
        if self.dummyThreadedReply == nil,
           let userid = dummyUser?.userid,
           let roomid = dummyRoom?.id,
           let replyto = dummyChatEvent?.id {
            testSendThreadedReply(roomid: roomid, userid: userid, replyto: replyto, command: "Test Threaded Reply!")
        }
        
        if self.dummyNotification == nil {
            listNotifications(
                userid: (dummyUser?.userid!)!,
                filternotificationtypes: [.chatreply],
                includeread: false,
                limit: 10
            )
        }
        
        let request = UserRequest.SetUserNotificationAsReadByChatEventId(
            userid: dummyUser!.userid ?? "",
            eventid: dummyNotification?.chateventid ?? "",
            read: true
        )
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        
        client.setUserNotificationAsReadByEventId(request) { (code, message, _, response) in
            print(message ?? "")
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssert(receivedCode == 200)
    }
    
    func test_UserServices_DeleteNotification() {
        // Run ChatClientTest.test_chatRoomsServicesSendQuotedReply() if dummNotification is empty
        
        if self.dummyUser == nil {
            test_UserServices_UpdateUser()
        }
        
        if self.dummyRoom == nil {
            createTestChatRoom(name: "Notification As Read Room - (\(Int64(Date().timeIntervalSince1970)))", enableactions: true, moderation: "post", enableenterandexit: true, roomisopen: true)
        }
        
        if self.dummyChatEvent == nil,
           let userid = dummyUser?.userid,
           let roomid = dummyRoom?.id {
            testExecuteCommand(roomid: roomid, userid: userid, command: "Test Comment!")
        }
        
        if self.dummyThreadedReply == nil,
           let userid = dummyUser?.userid,
           let roomid = dummyRoom?.id,
           let replyto = dummyChatEvent?.id {
            testSendThreadedReply(roomid: roomid, userid: userid, replyto: replyto, command: "Test Threaded Reply!")
        }
        
        if self.dummyNotification == nil {
            listNotifications(
                userid: (dummyUser?.userid!)!,
                filternotificationtypes: [.chatreply],
                includeread: false,
                limit: 10
            )
        }
        
        let request = UserRequest.DeleteUserNotification(
            userid: dummyUser!.userid ?? "",
            notificationid: dummyNotification?.id ?? ""
        )
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        
        client.deleteUserNotification(request) { (code, message, _, response) in
            print(message ?? "")
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssert(receivedCode == 200)
    }
    
    func test_UserServices_DeleteNotificationByEventId() {
        // Run ChatClientTest.test_chatRoomsServicesSendQuotedReply() if dummNotification is empty
        
        if self.dummyUser == nil {
            test_UserServices_UpdateUser()
        }
        
        if self.dummyRoom == nil {
            createTestChatRoom(name: "Notification As Read Room - (\(Int64(Date().timeIntervalSince1970)))", enableactions: true, moderation: "post", enableenterandexit: true, roomisopen: true)
        }
        
        if self.dummyChatEvent == nil,
           let userid = dummyUser?.userid,
           let roomid = dummyRoom?.id {
            testExecuteCommand(roomid: roomid, userid: userid, command: "Test Comment!")
        }
        
        if self.dummyThreadedReply == nil,
           let userid = dummyUser?.userid,
           let roomid = dummyRoom?.id,
           let replyto = dummyChatEvent?.id {
            testSendThreadedReply(roomid: roomid, userid: userid, replyto: replyto, command: "Test Threaded Reply!")
        }
        
        if self.dummyNotification == nil {
            listNotifications(
                userid: (dummyUser?.userid!)!,
                filternotificationtypes: [.chatreply],
                includeread: false,
                limit: 10
            )
        }
        
        let request = UserRequest.DeleteUserNotificationByChatEventId(
            userid: dummyUser!.userid ?? "",
            eventid: dummyNotification?.chateventid ?? ""
        )
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        
        client.deleteUserNotificationByEventId(request) { (code, message, _, response) in
            print(message ?? "")
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssert(receivedCode == 200)
    }
}

// MARK: - Convenience
extension UserClientTests {
    private func createUpdateUser() {
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        
        let request = UserRequest.CreateUpdateUser(
            userid: "9940A8C9-2332-48390F367D29",
            handle: "GeorgeWASHING",
            displayname: "George Washing",
            pictureurl: URL(string: "http://www.thepresidentshalloffame.com/media/reviews/photos/original/a9/c7/a6/44-1-george-washington-18-1549729902.jpg"),
            profileurl: URL(string: "http://www.thepresidentshalloffame.com/1-george-washington")
        )
        
        client.createOrUpdateUser(request) { (code, message, kind, user) in
            self.dummyUser = user
            expectation.fulfill()
        }
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
    }
    
    private func createUpdateOtherUser() {
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        
        let request = UserRequest.CreateUpdateUser(
            userid: "9940A8C9-2332-48390F367D30",
            handle: "JohnWICK",
            displayname: "John Wick",
            pictureurl: nil,
            profileurl: nil
        )
        
        client.createOrUpdateUser(request) { (code, message, kind, user) in
            self.otherUser = user
            expectation.fulfill()
        }
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
    }
    
    private func createTestChatRoom(
        name: String,
        customid: String? = nil,
        description: String? = nil,
        enableactions: Bool,
        moderation: String, // "post"/"pre"
        enableenterandexit: Bool,
        roomisopen: Bool
    ) {
        let request = ChatRequest.CreateRoom(
            name: name,
            customid: customid,
            description: description,
            moderation: moderation,
            enableactions: enableactions,
            enableenterandexit: enableenterandexit,
            roomisopen: roomisopen
        )

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        chatClient.createRoom(request) { (code, message, kind, data) in
            if let data {
                self.dummyRoom = data
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
    }
    
    private func joinChatRoom(
        roomid: String,
        userid: String
    ) {
        let request = ChatRequest.JoinRoom(roomid: roomid, userid: userid)
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        chatClient.joinRoom(request) { (code, message, kind, data) in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
    }
    
    private func testExecuteCommand(
        roomid: String,
        userid: String,
        command: String
    ) {
        let request = ChatRequest.ExecuteChatCommand(roomid: roomid, command: command, userid: userid)
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        do {
            try chatClient.executeChatCommand(request) { (code, message, kind, data) in
                if let event = data?.speech {
                    self.dummyChatEvent = event
                }
                expectation.fulfill()
            }
        } catch {
            print("UserClientTests::testExecuteCommand() -> error = \(error.localizedDescription)")
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
    }
    
    private func testSendThreadedReply(
        roomid: String,
        userid: String,
        replyto: String,    // Event ID to reply to
        command: String
    ) {
        let request = ChatRequest.SendThreadedReply(roomid: roomid, eventid: replyto, userid: userid, body: command)
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        do {
            try chatClient.sendThreadedReply(request) { (code, message, kind, data) in
                if let event = data {
                    self.dummyThreadedReply = event
                }
                expectation.fulfill()
            }
        } catch {
            print("UserClientTests::testSendThreadedReply() -> error = \(error.localizedDescription)")
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
    }
    
    private func listNotifications(
        userid: String,
        filternotificationtypes: [UserRequest.ListUserNotifications.FilterNotificationType]? = nil,
        includeread: Bool? = nil,
        filterchatroomid: String? = nil,
        filterchatroomcustomid: String? = nil,
        limit: Int? = nil
    ) {
        
        let request = UserRequest.ListUserNotifications(
            userid: userid,
            filternotificationtypes: filternotificationtypes,
            includeread: includeread,
            filterchatroomid: filterchatroomid,
            filterchatroomcustomid: filterchatroomcustomid,
            limit: limit
        )
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        
        client.listUserNotifications(request) { (code, message, _, response) in
            self.dummyNotification = response?.notifications?.first
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
    }
}

// MARK: - Convenience
extension UserClientTests {
    
    private func deleteUser(userid: String?) {
        guard let userid = userid else { return }
        
        let request = UserRequest.DeleteUser(userid: userid)
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        client.deleteUser(request) { (code, message, kind, data) in
            self.dummyUser = nil
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
    }
    
    private func deleteChatRoom(roomid: String?) {
        guard let roomid = roomid else { return }
        
        let request = ChatRequest.DeleteRoom(roomid: roomid)
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        chatClient.deleteRoom(request) { (code, message, kind, data) in
            self.dummyRoom = nil
            self.dummyChatEvent = nil
            self.dummyThreadedReply = nil
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
    }
    
    private func deleteNotification(userid: String?, notificationid: String?) {
        guard let userid = userid, let notificationid = notificationid else { return }
        
        let request = UserRequest.DeleteUserNotification(userid: userid, notificationid: notificationid)
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        client.deleteUserNotification(request) { (code, message, kind, data) in
            self.dummyNotification = nil
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
    }
    
}
