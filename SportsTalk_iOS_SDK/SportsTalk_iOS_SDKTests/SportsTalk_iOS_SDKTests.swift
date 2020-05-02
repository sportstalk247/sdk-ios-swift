import XCTest
import SportsTalk_iOS_SDK

let RESPONSE_PARAMETER_DATA = "data"
let RESPONSE_PARAMETER_MESSAGE = "message"
let RESPONSE_PARAMETER_USERS = "users"
let RESPONSE_PARAMETER_CODE = "code"

class SportsTalk_iOS_SDKTests: XCTestCase {
    
    let services = Services()
    
    let Expectation_Description = "Testing"
    var TEST_USERID = "9940A8C9-2332-4824-B628-48390F367D29"
    var TEST_HANDLE = "GeorgeWASHING"
    let TEST_BANNED = true
    let TEST_DESCRIPTION = "Testing"
    var TEST_DISPLAY_NAME = "George Washing"
    let TEST_PICTURE_URL = URL(string: "http://www.thepresidentshalloffame.com/media/reviews/photos/original/a9/c7/a6/44-1-george-washington-18-1549729902.jpg")
    let TEST_PROFILE_URL = URL(string: "http://www.thepresidentshalloffame.com/1-george-washington")
    var TEST_WEBHOOK_ID = "046282d5e2d249739e0080a4d2a04904"
    let TEST_PURGE_COMMAND = "*purge"
    let TEST_ROOM_NEWEST_EVENT_ID = ""
    
    var TEST_CHAT_ROOM_ID = ""//"5e95731138a2831340815d98"
    
    var TEST_CHAT_PER_MESSAGE_ID = "5e3a9f4838a2830ffc831425"
    let TEST_ROOM_ID_OR_SLUG = "5e0ec9b138a2831098526cac"
    let TEST_CUSTOM_EVENT = ""
    var TEST_REPLY_TO = ""
    let TEST_REACTION = "like"
    let TEST_REACTED = false
    let TEST_CUSTOM_ID = "5e0ec9b138a2831098526cac"
    let TEST_CUSTOM_PAYLOAD = ""
    let TEST_ROOM_ID_OR_LABEL = "5e95731138a2831340815d98"
    let TEST_EVENT_ID = "5e959bdb38a2831340816181"
    let TEST_CHAT_MESSAGE_ID = "5e3a9f4838a2830ffc831425"
    let TEST_CURSOR = ""
    var TEST_SLUG = URL(string: "www.roomtest1.com")
    let TEST_SLUG_STRING = "www.roomtest2.com"
    let TEST_ENABLEACTIONS = true
    let TEST_ENABLEENTERANDEXIT = false
    let TEST_ROOMISOPEN = false
    let TEST_THROTTLE = 0
    
    var TEST_COMMENT_ID = ""
    var TEST_CONVERSATION_ID_NEW = "testIdMeantToBeCreatedAndDeleted"
    
    var TEST_WEBHOOKS_ID = ""
    var TEST_WEBHOOKS_PRR_ID = "5e96e73f38a28309a011a6b6"
    
    let RESPONSE_PARAMETER_DISPLAY_NAME = "displayname"
    let RESPONSE_PARAMETER_HANDLE = "handle"
    let RESPONSE_PARAMETER_PROFILE_URL = "profileurl"
    let RESPONSE_PARAMETER_PICTURE_URL = "pictureurl"
    let TIMEOUT: Double = 10
    var RESPONSE_MODERATIONQUEUE: [[String:Any]]?
    
    struct Constants {
        static let url = URL(string: "https://api.sportstalk247.com/api/v3")
        static let appId = "5e92a5ce38a28d0b6453687a"
        static let authToken = "QZF6YKDKSUCeL03tdA2l2gx4ckSvC7LkGsgmix-pBZLA"
        static let commentConversationId = "Demo_Conversation"
        static let commentCommentId = "5e92b15d38a28d0b64536887"
        static let commentOwnerId = "brenn"
        static let customId = "/articles/2020-03-01/article1/something-very-important-happened"
        static let propertyId = "sportstalk247.com/apidemo"
        
    }

    
    override func setUp() {
        services.url =  Constants.url
        services.appId = Constants.appId
        services.authToken = Constants.authToken
        services.debug = true
    }
    
    private func getDateTimeString() -> String{
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let date = Date()
        return dateFormatter.string(from: date)
    }
    
    // MARK: - Users APIs
    func test_UserServices_UpdateUser()
    {
        let createUser = UsersServices.CreateUpdateUser()
        
        createUser.userid =  UUID().uuidString
        createUser.handle = "Sam"
        createUser.displayname = "Sam"
        createUser.pictureurl = TEST_PICTURE_URL
        createUser.profileurl = TEST_PROFILE_URL

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?
        var code = 0
        services.ams.usersServices(createUser) { (response) in
            code = response[RESPONSE_PARAMETER_CODE] as? Int ?? 0
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            self.TEST_USERID = responseData?["userid"] as? String ?? ""
            self.TEST_DISPLAY_NAME = responseData?["displayname"] as? String ?? ""
            self.TEST_HANDLE = responseData?["handle"] as? String ?? ""
            expectation.fulfill()
        }

        waitForExpectations(timeout: TIMEOUT, handler: nil)

        XCTAssertEqual(TEST_PICTURE_URL?.absoluteString, responseData?[RESPONSE_PARAMETER_PICTURE_URL] as? String)
        XCTAssertTrue(code == 200)
    }
    
    func test_UserServices_DeleteUser()
    {
        test_UserServices_UpdateUser()
        let createUser = UsersServices.DeleteUser()
        createUser.userid = TEST_USERID
        print("user id \(TEST_USERID)")
        let expectation = self.expectation(description: Expectation_Description)
        var code = 0

        services.ams.usersServices(createUser) { (response) in
            code = response[RESPONSE_PARAMETER_CODE] as? Int ?? 0
            expectation.fulfill()
        }

        waitForExpectations(timeout: TIMEOUT, handler: nil)

        XCTAssertTrue(code == 200)
    }

    func test_UserServices_GetUserDetails()
    {
        test_UserServices_UpdateUser()
        let getUserDetail = UsersServices.GetUserDetails()
        getUserDetail.userid = TEST_USERID

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?

        services.ams.usersServices(getUserDetail) { (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            expectation.fulfill()
        }

        waitForExpectations(timeout: TIMEOUT, handler: nil)

        XCTAssertEqual(TEST_DISPLAY_NAME, responseData?[RESPONSE_PARAMETER_DISPLAY_NAME] as? String)
        XCTAssertEqual(TEST_HANDLE, responseData?[RESPONSE_PARAMETER_HANDLE] as? String)
        XCTAssertEqual(TEST_PROFILE_URL?.absoluteString, responseData?[RESPONSE_PARAMETER_PROFILE_URL] as? String)
    }

    func test_UserServices_ListUsers()
    {
        test_UserServices_UpdateUser()
        test_UserServices_UpdateUser()
        let listUsers = UsersServices.ListUsers()
        listUsers.limit = "2"

        let expectation = self.expectation(description: Expectation_Description)
        var usersData:[[AnyHashable:Any]]?

        services.ams.usersServices(listUsers) { (response) in
            let responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            usersData = responseData?[RESPONSE_PARAMETER_USERS] as? [[AnyHashable:Any]]
            expectation.fulfill()
        }

        waitForExpectations(timeout: TIMEOUT, handler: nil)
        XCTAssertEqual(2, usersData?.count)
    }

    func test_UserServices_ListUsersMore()
    {
        test_UserServices_UpdateUser()
        test_UserServices_UpdateUser()
        test_UserServices_UpdateUser()
        test_UserServices_UpdateUser()
        test_UserServices_UpdateUser()
        let listUsersMore = UsersServices.ListUsersMore()
        listUsersMore.limit = "5"

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?
        var usersData = NSArray()

        services.ams.usersServices(listUsersMore) { (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            usersData = responseData?[RESPONSE_PARAMETER_USERS] as? NSArray ?? NSArray()
            expectation.fulfill()
        }

        waitForExpectations(timeout: TIMEOUT, handler: nil)
        XCTAssertEqual(5, usersData.count)
    }
    
    func test_UserServices_BanUser()
    {
        test_UserServices_UpdateUser()
        let banUser = UsersServices.BanUser()
        banUser.userid = TEST_USERID
        let expectation = self.expectation(description: Expectation_Description)
        var banned:Bool?

        services.ams.usersServices(banUser){ (response) in
            if let data = response[RESPONSE_PARAMETER_DATA] as? [String:Any]{
                banned = data["banned"] as? Bool
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: TIMEOUT, handler: nil)
        XCTAssertTrue(banned ?? false)
    }

    func test_UserServices_RestoreUser()
    {
        test_UserServices_BanUser()
        let restoreUser = UsersServices.RestoreUser()
        restoreUser.userid = TEST_USERID

        let expectation = self.expectation(description: Expectation_Description)
        var banned: Bool? = false

        services.ams.usersServices(restoreUser){ (response) in
            if let data = response[RESPONSE_PARAMETER_DATA] as? [String:Any]{
                banned = data["banned"] as? Bool
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: TIMEOUT, handler: nil)

        XCTAssertTrue(!(banned ?? true))
    }
    
    func test_UserServices_SearchUsersByHandle()
    {
        test_UserServices_UpdateUser()
       let searchUsersByHandle = UsersServices.SearchUsersByHandle()
       searchUsersByHandle.handle = TEST_HANDLE
       searchUsersByHandle.limit = "5"

       var users:[[AnyHashable:Any]]?
       let expectation = self.expectation(description: Expectation_Description)

       services.ams.usersServices(searchUsersByHandle) { (response) in
           let responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
           users = responseData?[RESPONSE_PARAMETER_USERS] as? [[AnyHashable:Any]]

           expectation.fulfill()
       }

       waitForExpectations(timeout: TIMEOUT, handler: nil)

        XCTAssert((users?.count ?? 0) > 0)

    }

    func test_UserServices_SearchUsersByName()
    {
        test_UserServices_UpdateUser()
        let searchUsersByName = UsersServices.SearchUsersByName()
        searchUsersByName.name = TEST_DISPLAY_NAME

        var users:[[AnyHashable:Any]]?
        let expectation = self.expectation(description: Expectation_Description)

        services.ams.usersServices(searchUsersByName) { (response) in
            let responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            users = responseData?[RESPONSE_PARAMETER_USERS] as? [[AnyHashable:Any]]
            expectation.fulfill()
        }

        waitForExpectations(timeout: TIMEOUT, handler: nil)

        XCTAssert((users?.count ?? 0) > 0)
    }

    func test_UserServices_SearchUsersByUserId()
    {
        test_UserServices_UpdateUser()
        let searchUsersByUserId = UsersServices.SearchUsersByUserId()
        searchUsersByUserId.userId = TEST_USERID

        var users:[[AnyHashable:Any]]?
        let expectation = self.expectation(description: Expectation_Description)

        services.ams.usersServices(searchUsersByUserId) { (response) in
            let responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            users = responseData?[RESPONSE_PARAMETER_USERS] as? [[AnyHashable:Any]]

            expectation.fulfill()
        }

        waitForExpectations(timeout: TIMEOUT, handler: nil)

        XCTAssert((users?.count ?? 0) > 0)
    }
    // MARK: - Chat APIs
    
    func test_ChatRoomsServices_CreateRoomPostmoderated()
    {
        test_UserServices_UpdateUser()
        let createRoom = ChatRoomsServices.CreateRoomPostmoderated()
        createRoom.name = "Test Room Post Moderated 3"
        createRoom.slug = "post-test-room-\(getDateTimeString())"
        createRoom.description = "Chat Room Newly Created"
        createRoom.enableactions = TEST_ENABLEACTIONS
        createRoom.enableenterandexit = TEST_ENABLEENTERANDEXIT
        createRoom.roomisopen = true
        createRoom.userid = TEST_USERID

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?

        services.ams.chatRoomsServices(createRoom){ (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            self.TEST_CHAT_ROOM_ID = (responseData?["id"] as? String) ?? ""
            self.TEST_SLUG = URL(string: responseData?["slug"] as? String ?? "")
            expectation.fulfill()
        }

        waitForExpectations(timeout: TIMEOUT, handler: nil)

        XCTAssertTrue(responseData != nil)
    }
    
    func test_ChatRoomsServices_CreateRoomPremoderated()
    {
        test_UserServices_UpdateUser()
        let createRoom = ChatRoomsServices.CreateRoomPremoderated()
        createRoom.name = "Test Room Pre Moderated 1"
        createRoom.slug = "test-room-pre-moderated-\(getDateTimeString())"
        createRoom.description = "Chat Room Newly Created (Premoderated)"
        createRoom.enableactions = TEST_ENABLEACTIONS
        createRoom.enableenterandexit = TEST_ENABLEENTERANDEXIT
        createRoom.roomisopen = true
        createRoom.userid = TEST_USERID
        createRoom.maxreports = 0

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?

        services.ams.chatRoomsServices(createRoom){ (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            self.TEST_CHAT_ROOM_ID = (responseData?["id"] as? String) ?? ""
            self.TEST_SLUG = URL(string: responseData?["slug"] as? String ?? "")
            expectation.fulfill()
        }

        waitForExpectations(timeout: TIMEOUT, handler: nil)

        XCTAssertTrue(responseData != nil)
    }
    
    func test_ChatRoomsServices_GetRoomDetails()
    {
        test_ChatRoomsServices_CreateRoomPostmoderated()
        let getRoomDetails = ChatRoomsServices.GetRoomDetails()
        getRoomDetails.roomIdOrSlug = TEST_CHAT_ROOM_ID

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?

        services.ams.chatRoomsServices(getRoomDetails){ (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            expectation.fulfill()
        }

        waitForExpectations(timeout: TIMEOUT, handler: nil)

        XCTAssertTrue(responseData != nil)
    }
    
    func test_ChatRoomsServices_DeleteRoom()
    {
        test_ChatRoomsServices_CreateRoomPostmoderated()
        let request = ChatRoomsServices.DeleteRoom()
        request.roomid = TEST_CHAT_ROOM_ID
        request.userid = TEST_USERID
        
        let expectation = self.expectation(description: Expectation_Description)
        var code = 200

        services.ams.chatRoomsServices(request){ (response) in
            code = response[RESPONSE_PARAMETER_CODE] as? Int ?? 0
            expectation.fulfill()
        }

        waitForExpectations(timeout: TIMEOUT, handler: nil)

        XCTAssertTrue(code == 200)
    }
    
    func test_ChatRoomsServices_UpdateRoom()
    {
        test_ChatRoomsServices_CreateRoomPostmoderated()
        let updateRoom = ChatRoomsServices.UpdateRoom()
        updateRoom.name = TEST_DISPLAY_NAME
        updateRoom.slug = TEST_SLUG
        updateRoom.description = TEST_DESCRIPTION
        updateRoom.enableactions = TEST_ENABLEACTIONS
        updateRoom.enableenterandexit = TEST_ENABLEENTERANDEXIT
        updateRoom.roomisopen = true
        updateRoom.userid = TEST_USERID
        updateRoom.roomid = TEST_CHAT_ROOM_ID
        updateRoom.throttle = TEST_THROTTLE


        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?

        services.ams.chatRoomsServices(updateRoom){ (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            print(response)
            expectation.fulfill()
        }

        waitForExpectations(timeout: TIMEOUT, handler: nil)

        XCTAssertTrue(responseData != nil)
    }

    func test_ChatRoomsServices_UpdateRoomCloseARoom()
    {
        test_ChatRoomsServices_CreateRoomPostmoderated()
        let updateRoomCloseARoom = ChatRoomsServices.UpdateRoomCloseARoom()
        updateRoomCloseARoom.slug = TEST_SLUG
        updateRoomCloseARoom.roomisopen = TEST_ROOMISOPEN
        updateRoomCloseARoom.roomid = TEST_CHAT_ROOM_ID

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?

        services.ams.chatRoomsServices(updateRoomCloseARoom){ (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            print(response)
            expectation.fulfill()
        }

        waitForExpectations(timeout: TIMEOUT, handler: nil)

        XCTAssertTrue(responseData != nil)
    }
    
    func test_ChatRoomsServices_ListRooms()
    {
        let listRooms = ChatRoomsServices.ListRooms()
        
        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?
        
        services.ams.chatRoomsServices(listRooms){ (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            print(response)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertTrue(responseData != nil)
    }
    
    func test_ChatRoomsServices_JoinRoomAuthenticatedUser()
    {
        if TEST_CHAT_ROOM_ID.isEmpty{
            test_ChatRoomsServices_CreateRoomPostmoderated()
        }
        let joinRoomAuthenticatedUser = ChatRoomsServices.JoinRoomAuthenticatedUser()
        joinRoomAuthenticatedUser.userid = TEST_USERID
        joinRoomAuthenticatedUser.displayname = TEST_DISPLAY_NAME
        joinRoomAuthenticatedUser.roomid = TEST_CHAT_ROOM_ID

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?

        services.ams.chatRoomsServices(joinRoomAuthenticatedUser){ (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            expectation.fulfill()
        }

        waitForExpectations(timeout: TIMEOUT, handler: nil)

        XCTAssertTrue(responseData != nil)
    }

    func test_ChatRoomsServices_JoinRoomAnonymousUser()
    {
        test_ChatRoomsServices_CreateRoomPostmoderated()
        let joinRoomAnonymousUser = ChatRoomsServices.JoinRoomAnonymousUser()
        joinRoomAnonymousUser.roomid = TEST_CHAT_ROOM_ID

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?

        services.ams.chatRoomsServices(joinRoomAnonymousUser){ (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            print(response)
            expectation.fulfill()
        }

        waitForExpectations(timeout: TIMEOUT, handler: nil)

        XCTAssertTrue(responseData != nil)
    }
    
    func test_ChatRoomsServices_ListRoomParticipants()
    {
        test_ChatRoomsServices_JoinRoomAuthenticatedUser()
        let listRoomParticipants = ChatRoomsServices.ListRoomParticipants()
        listRoomParticipants.cursor = TEST_CURSOR
        listRoomParticipants.roomid = TEST_CHAT_ROOM_ID

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?

        services.ams.chatRoomsServices(listRoomParticipants){ (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            print(response)
            expectation.fulfill()
        }

        waitForExpectations(timeout: TIMEOUT, handler: nil)

        XCTAssertTrue(responseData != nil)
    }
    
    func test_ChatRoomsServices_ExitRoom()
    {
        test_ChatRoomsServices_JoinRoomAuthenticatedUser()

        let exitRoom = ChatRoomsServices.ExitRoom()
        exitRoom.roomId = TEST_CHAT_ROOM_ID
        exitRoom.userid = TEST_USERID

        let expectation = self.expectation(description: Expectation_Description)
        var code = 0

        services.ams.chatRoomsServices(exitRoom){ (response) in
            code = response["code"] as? Int ?? 0
            expectation.fulfill()
        }

        waitForExpectations(timeout: TIMEOUT, handler: nil)

        XCTAssertTrue(code == 200)
    }
    
    func test_ChatRoomsServices_GetUpdates()
    {
        test_ChatRoomsServices_ExecuteChatCommand()
        let getUpdates = ChatRoomsServices.GetUpdates()
        getUpdates.roomId = TEST_CHAT_ROOM_ID

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?

        services.ams.chatRoomsServices(getUpdates){ (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            print(response)
            expectation.fulfill()
        }

        waitForExpectations(timeout: TIMEOUT, handler: nil)

        XCTAssertTrue(responseData != nil)
    }

    func test_ChatRoomsServices_GetUpdatesMore()
    {
        test_ChatRoomsServices_ExecuteChatCommand()
        let getUpdatesMore = ChatRoomsServices.GetUpdatesMore()
        getUpdatesMore.roomIdOrLabel = TEST_CHAT_ROOM_ID
        getUpdatesMore.eventid = TEST_REPLY_TO

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[[AnyHashable:Any]]?

        services.ams.chatRoomsServices(getUpdatesMore){ (response) in
            let data = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            responseData = data?["events"] as? [[AnyHashable:Any]]
            expectation.fulfill()
        }

        waitForExpectations(timeout: TIMEOUT, handler: nil)

        XCTAssertTrue(responseData != nil && responseData!.isEmpty)
    }
    
     func test_ChatRoomsServices_ExecuteChatCommand()
    {
        test_ChatRoomsServices_JoinRoomAuthenticatedUser()
        let executeChatCommand = ChatRoomsServices.ExecuteChatCommand()
        executeChatCommand.roomId = TEST_CHAT_ROOM_ID
        executeChatCommand.command = "Hello New Command"
        executeChatCommand.userid = TEST_USERID

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?

        services.ams.chatRoomsServices(executeChatCommand){ (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            let speach = responseData?["speech"] as? [String:Any]
            self.TEST_REPLY_TO = speach?["id"] as? String ?? ""
            expectation.fulfill()
        }

        waitForExpectations(timeout: TIMEOUT, handler: nil)

        XCTAssertTrue(responseData != nil)
    }
    
    func test_ChatRoomsServices_ExecuteDanceAction()
    {
        test_ChatRoomsServices_JoinRoomAuthenticatedUser()
        
        let executeDanceAction = ChatRoomsServices.ExecuteDanceAction()
        executeDanceAction.roomId = TEST_CHAT_ROOM_ID
        executeDanceAction.command = "/high5 georgew"
        executeDanceAction.userid = TEST_USERID
        executeDanceAction.customtype = TEST_CUSTOM_EVENT
        executeDanceAction.customid = TEST_CUSTOM_ID
        executeDanceAction.custompayload = TEST_CUSTOM_PAYLOAD

        let expectation = self.expectation(description: Expectation_Description)
        var code = 0

        services.ams.chatRoomsServices(executeDanceAction){ (response) in
            code = (response["code"] as? Int) ?? 0
            expectation.fulfill()
        }

        waitForExpectations(timeout: TIMEOUT, handler: nil)

        XCTAssertTrue(code == 200)
    }
    
     func test_ChatRoomsServices_ReplyToAMessage()
     {
        test_ChatRoomsServices_ExecuteChatCommand()
         let replyToAMessage = ChatRoomsServices.ReplyToAMessage()
         replyToAMessage.roomId = TEST_CHAT_ROOM_ID
         replyToAMessage.command = "This is my reply"
         replyToAMessage.userid = TEST_USERID
         replyToAMessage.replyto = TEST_REPLY_TO

         let expectation = self.expectation(description: Expectation_Description)
         var responseData:[AnyHashable:Any]?

         services.ams.chatRoomsServices(replyToAMessage){ (response) in
             responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
             expectation.fulfill()
         }

         waitForExpectations(timeout: TIMEOUT, handler: nil)

         XCTAssertTrue(responseData != nil)
     }
    
    func test_ChatRoomsServices_ListMessagesByUsers()
    {
        test_ChatRoomsServices_ExecuteChatCommand()
        let request = ChatRoomsServices.ListMessagesByUser()
        request.limit = "4"
        request.roomid = TEST_CHAT_ROOM_ID
        request.userId = TEST_USERID

        var responseData:[AnyHashable:Any]?
        let expectation = self.expectation(description: Expectation_Description)

        services.ams.chatRoomsServices(request) { (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            expectation.fulfill()
        }
        waitForExpectations(timeout: TIMEOUT, handler: nil)
        XCTAssert((responseData?.count ?? 0) > 0)
    }
    
    func test_ChatRoomsServices_RemoveMessage()
       {
        test_ChatRoomsServices_ExecuteChatCommand()
           let removeMessage = ChatRoomsServices.RemoveMessage()
           removeMessage.chatMessageId = TEST_REPLY_TO // contains newest messsage id
           removeMessage.chatRoomId = TEST_CHAT_ROOM_ID

           let expectation = self.expectation(description: Expectation_Description)
           var responseData:[AnyHashable:Any]?

           services.ams.chatRoomsServices(removeMessage){ (response) in
               responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
               print(response)
               expectation.fulfill()
           }

           waitForExpectations(timeout: TIMEOUT, handler: nil)

           XCTAssertTrue(responseData != nil)
       }
    
    func test_ChatRoomsServices_PurgeUserMessages()
    {
        test_ChatRoomsServices_ExecuteChatCommand()
        let removeMessage = ChatRoomsServices.PurgeUserMessages()
        removeMessage.command = "*purge zola \(TEST_USERID)"
        removeMessage.userid = TEST_USERID
        removeMessage.chatroomid = TEST_CHAT_ROOM_ID

        let expectation = self.expectation(description: Expectation_Description)
        var code = 0

        services.ams.chatRoomsServices(removeMessage){ (response) in
            code = (response["code"] as? Int) ?? 0
            expectation.fulfill()
        }

        waitForExpectations(timeout: TIMEOUT, handler: nil)

        XCTAssertTrue(code == 200)
    }
    
    func test_ChatRoomsServices_ReportMessage()
    {
        test_ChatRoomsServices_CreateRoomPremoderated()
        test_ChatRoomsServices_ExecuteChatCommand()
        let reportMessage = ChatRoomsServices.ReportMessage()
        reportMessage.chat_room_newest_speech_id = TEST_REPLY_TO
        reportMessage.chatRoomId = TEST_CHAT_ROOM_ID
        reportMessage.userid = TEST_USERID

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?

        services.ams.chatRoomsServices(reportMessage){ (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            print(response)
            expectation.fulfill()
        }

        waitForExpectations(timeout: TIMEOUT, handler: nil)

        XCTAssertTrue(responseData != nil)
    }
    
    func test_ChatRoomsServices_ReactToAMessageLike()
    {
        test_ChatRoomsServices_ExecuteChatCommand()
        let request = ChatRoomsServices.ReactToAMessageLike()
        request.roomId = TEST_CHAT_ROOM_ID
        request.roomNewestEventId = TEST_REPLY_TO
        request.userid = TEST_USERID
        request.reaction = "like"
        request.reacted = "true"
        
        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?

        services.ams.chatRoomsServices(request){ (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            print(response)
            expectation.fulfill()
        }

        waitForExpectations(timeout: TIMEOUT, handler: nil)

        XCTAssertTrue(responseData != nil)
    }
    

     func test_ChatRoomsServices_ExecuteAdminCommand()
     {
         test_ChatRoomsServices_JoinRoomAuthenticatedUser()

         let executeAdminCommand = ChatRoomsServices.ExecuteAdminCommand()
         executeAdminCommand.roomId = TEST_CHAT_ROOM_ID
         executeAdminCommand.command = "*help"
         executeAdminCommand.userid = TEST_USERID
         executeAdminCommand.customtype = TEST_CUSTOM_EVENT
         executeAdminCommand.customid = TEST_CUSTOM_ID
         executeAdminCommand.custompayload = TEST_CUSTOM_PAYLOAD

         let expectation = self.expectation(description: Expectation_Description)
         var responseMessage:String?

         services.ams.chatRoomsServices(executeAdminCommand){ (response) in
             responseMessage = response[RESPONSE_PARAMETER_MESSAGE] as? String
             expectation.fulfill()
         }

         waitForExpectations(timeout: TIMEOUT, handler: nil)

         XCTAssertTrue(responseMessage != nil)
     }

    func test_ChatRoomsServices_DeleteAllEventsInRoom()
    {
        test_ChatRoomsServices_ExecuteChatCommand()
        let deleteAllEventsInRoom = ChatRoomsServices.DeleteAllEventsInRoom()
        deleteAllEventsInRoom.userid = TEST_USERID
        deleteAllEventsInRoom.command = "*deleteallevents zola"
        deleteAllEventsInRoom.chatroomid = TEST_CHAT_ROOM_ID
        
        let expectation = self.expectation(description: Expectation_Description)
        var code = 200
        
        services.ams.chatRoomsServices(deleteAllEventsInRoom){ (response) in
            code = response[RESPONSE_PARAMETER_CODE] as? Int ?? 0
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: TIMEOUT, handler: nil)
        
        XCTAssertTrue(code == 200)
    }
    // MARK: - Moderation APIs
    func test_ModerationServices_ApproveMessage()
    {
        var messageId = ""
        var chatRoomId = ""
        test_ModerationServices_ListMessagesNeedingModeration()
        if let data = self.RESPONSE_MODERATIONQUEUE?.first{
            messageId = data["id"] as? String ?? ""
            chatRoomId = data["roomid"] as? String ?? ""
        }
        let approveMessage = ModerationServices.ApproveMessage()
        approveMessage.chatMessageId = messageId
        approveMessage.chatRoomId = chatRoomId

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?

        services.ams.moderationServices(approveMessage){ (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            expectation.fulfill()
        }

        waitForExpectations(timeout: TIMEOUT, handler: nil)

        XCTAssertTrue(responseData != nil)
    }
    func test_ModerationServices_ListMessagesNeedingModeration()
    {
        test_ChatRoomsServices_ReportMessage()
        let request = ModerationServices.ListMessagesNeedingModeration()
        
        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?

        services.ams.moderationServices(request){ (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            self.RESPONSE_MODERATIONQUEUE = responseData?["events"] as? [[String:Any]]
            expectation.fulfill()
        }

        waitForExpectations(timeout: TIMEOUT, handler: nil)

        XCTAssertTrue(responseData != nil)
    }
    
    func test_ModerationServices_ApproveCommentInQueue()
    {
        let request = ModerationServices.ApproveCommentInQueue()
        request.commentid = "5e99869038a2831b30be124a"

        let expectation = self.expectation(description: Expectation_Description)
        
        var code = 0
        services.ams.moderationServices(request){ (response) in
            code = response[RESPONSE_PARAMETER_CODE] as? Int ?? 0
            expectation.fulfill()
        }

        waitForExpectations(timeout: TIMEOUT, handler: nil)

        XCTAssertTrue(code == 200)
    }
    
    func test_ModerationServices_RejectCommentInQueue()
    {
        let request = ModerationServices.ApproveCommentInQueue()
        request.commentid = "5e998cf038a2831b30be124f"

        let expectation = self.expectation(description: Expectation_Description)
        
        var code = 0
        services.ams.moderationServices(request){ (response) in
            code = response[RESPONSE_PARAMETER_CODE] as? Int ?? 0
            expectation.fulfill()
        }

        waitForExpectations(timeout: TIMEOUT, handler: nil)

        XCTAssertTrue(code == 200)
    }
    
    func test_ModerationServices_ListCommentsInModerationQueue()
    {
        let request = ModerationServices.ListCommentsInModerationQueue()
        
        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?

        services.ams.moderationServices(request){ (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            expectation.fulfill()
        }

        waitForExpectations(timeout: TIMEOUT, handler: nil)

        XCTAssertTrue(responseData != nil)
    }

    // MARK: - Webhooks APIs
    func test_Webhooks_CreateOrReplaceWebhookPrepublish(){
        let request = WebhooksServices.CreateReplaceWebhook()
        request.label = "Demo Webhook prepublish"
        request.enabled = false
        request.events = ["chatspeech", "chatreply", "chatquote", "commentpublished", "commentreply"]
        request.type = "prepublish"
        request.url = URL(string: "https://localhost:3000")
        
        let expectation = self.expectation(description: Expectation_Description)
        var code = 0
        services.ams.webhooksServices(request) { (response) in
            let data = response[RESPONSE_PARAMETER_DATA] as? [String: Any]
            self.TEST_WEBHOOK_ID = data?["id"] as? String ?? ""
            code = response[RESPONSE_PARAMETER_CODE] as? Int ?? 0
            expectation.fulfill()
        }
        waitForExpectations(timeout: TIMEOUT, handler: nil)
        
        XCTAssertTrue(code == 200)
    }
    
    func test_Webhooks_CreateOrReplaceWebhookPostpublish(){
           let request = WebhooksServices.CreateReplaceWebhook()
           request.label = "Demo Webhook Post Publish"
           request.enabled = false
           request.events = ["commentreply"]
           request.type = "postpublish"
           request.url = URL(string: "https://localhost:8080")
           
           let expectation = self.expectation(description: Expectation_Description)
           var code = 0
           services.ams.webhooksServices(request) { (response) in
            let data = response[RESPONSE_PARAMETER_DATA] as? [String: Any]
            self.TEST_WEBHOOK_ID = data?["id"] as? String ?? ""
               code = response[RESPONSE_PARAMETER_CODE] as? Int ?? 0
               expectation.fulfill()
           }
           waitForExpectations(timeout: TIMEOUT, handler: nil)
           
           XCTAssertTrue(code == 200)
       }
    
    func test_Webhooks_ListWebhooks(){
        let request = WebhooksServices.ListWebhooks()
        
        let expectation = self.expectation(description: Expectation_Description)
        var code = 0
        services.ams.webhooksServices(request) { (response) in
            code = response[RESPONSE_PARAMETER_CODE] as? Int ?? 0
            expectation.fulfill()
        }
        waitForExpectations(timeout: TIMEOUT, handler: nil)
        
        XCTAssertTrue(code == 200)
    }
    
    func test_Webhooks_UpdateWebhook(){
        let request = WebhooksServices.UpdateWebhook()
        request.webhookId = "5e9eaf9c38a28519349632a1"
        request.label = "Demo Webhook Post Publish"
        request.enabled = true
        request.events = ["commentreply"]
        request.type = "postpublish"
        request.url = URL(string: "https://localhost:8085")
        let expectation = self.expectation(description: Expectation_Description)
        var code = 0
        services.ams.webhooksServices(request) { (response) in
            code = response[RESPONSE_PARAMETER_CODE] as? Int ?? 0
            expectation.fulfill()
        }
        waitForExpectations(timeout: TIMEOUT, handler: nil)
        
        XCTAssertTrue(code == 200)
    }
    
    func test_Webhooks_DeleteWebHook(){
        test_Webhooks_CreateOrReplaceWebhookPrepublish()
        let request = WebhooksServices.DeleteWebhook()
        request.webhookId = TEST_WEBHOOK_ID
        
        let expectation = self.expectation(description: Expectation_Description)
        var code = 0
        services.ams.webhooksServices(request) { (response) in
            code = response[RESPONSE_PARAMETER_CODE] as? Int ?? 0
            expectation.fulfill()
        }
        waitForExpectations(timeout: TIMEOUT, handler: nil)
        
        XCTAssertTrue(code == 200)
    }
   
    // MARK: - Comment APIs
    func test_Comments_CreateAndUpdateConversation(){
        let request = CommentsService.CreateUpdateConversation()
        
        request.conversationid = TEST_CONVERSATION_ID_NEW
        request.owneruserid = "userid_georgew"
        request.property = "sportstalk247.com/apidemo/testnew1"
        request.moderation = "post"
        request.maxreports = 0
        request.title = "Conversation Test New"
        request.maxcommentlen = 512
        request.open = true
        request.tags = ["tags", "tagb"]
        request.customid = "/articles/2020-03-01/article1/something-\(getDateTimeString())"
        request.udf1 = "/sample/userdefined1/emojis/😂🤣❤😍😒"
        request.udf2 = "/sample/userdefined2/intl/characters/äöüÄÖÜß"
        
        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?
        
        services.ams.commentsServices(request) {response in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            expectation.fulfill()
        }
        waitForExpectations(timeout: TIMEOUT, handler: nil)

        XCTAssertTrue(responseData != nil)
    }
    
    func test_Comments_GetConversationById(){
        let request = CommentsService.GetConversationById()
        request.comment_conversation_id = Constants.commentConversationId
        
        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?
        
        services.ams.commentsServices(request) {response in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            expectation.fulfill()
        }
        waitForExpectations(timeout: TIMEOUT, handler: nil)

        XCTAssertTrue(responseData != nil)
    }
    
    func test_Comments_FindConversationByCustomId(){
        let request = CommentsService.FindConversationByIdCustomId()
        request.customid = "/articles/2020-03-01/article1/something-very-important-happened-test"//Constants.customId
        
        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?
        
        services.ams.commentsServices(request) {response in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            expectation.fulfill()
        }
        waitForExpectations(timeout: TIMEOUT, handler: nil)
        
        XCTAssertTrue(responseData != nil)
    }
    
    func test_Comments_ListConversation(){
        let request = CommentsService.ListConversations()
        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]? = [:]
        
        services.ams.commentsServices(request) {response in
            print("Response \(response)")
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            expectation.fulfill()
        }
        waitForExpectations(timeout: TIMEOUT, handler: nil)
        
        XCTAssertTrue(responseData != nil)
    }
    
    func test_Comments_ListConversationWithFilters(){
        
        let request = CommentsService.ListConversationsWithFilters()
        request.propertyid = Constants.propertyId

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?
        
        services.ams.commentsServices(request) {response in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            expectation.fulfill()
        }
        waitForExpectations(timeout: TIMEOUT, handler: nil)
        
        XCTAssertTrue(responseData != nil)
    }
    
    func test_Comments_DeleteConversation(){
        test_Comments_CreateAndUpdateConversation()
        let request = CommentsService.DeleteConversation()
        request.comment_conversation_id = TEST_CONVERSATION_ID_NEW
        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?
        
        services.ams.commentsServices(request) {response in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            expectation.fulfill()
        }
        waitForExpectations(timeout: TIMEOUT, handler: nil)
        
        XCTAssertTrue(responseData != nil)
    }
    
    func test_Comments_CreateAndPublishData(){
        let request = CommentsService.CreateAndPublishComment()
        request.comment_conversation_id = Constants.commentConversationId
        request.userid = "userid_georgew"
        request.body = "A new Comment"
        request.tags = ["tag1","tag2"]
        
        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?
        
        services.ams.commentsServices(request) {response in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            self.TEST_COMMENT_ID = responseData?["id"] as? String ?? ""
            expectation.fulfill()
        }
        waitForExpectations(timeout: TIMEOUT, handler: nil)
        
        XCTAssertTrue(responseData != nil)
    }
    
    func test_Comments_ReplyToAComment(){
        
        let request = CommentsService.ReplyToAComment()
        request.comment_conversation_id = Constants.commentConversationId
        request.comment_comment_id = Constants.commentCommentId
        request.userid = "userid_georgew"
        request.body = "A new reply"

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?
        
        services.ams.commentsServices(request) {response in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            expectation.fulfill()
        }
        waitForExpectations(timeout: TIMEOUT, handler: nil)
        
        XCTAssertTrue(responseData != nil)
    }
    
    func test_Comments_GetCommentByid(){
        
        let request = CommentsService.GetCommentById()
        request.comment_conversation_id = Constants.commentConversationId
        request.comment_comment_id = Constants.commentCommentId

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?
        
        services.ams.commentsServices(request) {response in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            expectation.fulfill()
        }
        waitForExpectations(timeout: TIMEOUT, handler: nil)
        
        XCTAssertTrue(responseData != nil)
    }
    
    func test_Comments_ListComments(){
        let request = CommentsService.ListComments()
        request.comment_conversation_id = Constants.commentConversationId
        request.includeinactive = true
        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?
        
        services.ams.commentsServices(request) {response in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            expectation.fulfill()
        }
        waitForExpectations(timeout: TIMEOUT, handler: nil)
        
        XCTAssertTrue(responseData != nil)
    }
    
    func test_Comments_ListCommentsIncludeChildren(){
        let request = CommentsService.ListComments()
        request.comment_conversation_id = Constants.commentConversationId
        request.includechildren = true
        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?
        
        services.ams.commentsServices(request) {response in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            expectation.fulfill()
        }
        waitForExpectations(timeout: TIMEOUT, handler: nil)
        
        XCTAssertTrue(responseData != nil)
    }
    
    func test_Comments_ListReplies(){
        
        let request = CommentsService.ListReplies()
        request.comment_conversation_id = Constants.commentConversationId
        request.comment_comment_id = Constants.commentCommentId

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?
        
        services.ams.commentsServices(request) {response in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            expectation.fulfill()
        }
        waitForExpectations(timeout: TIMEOUT, handler: nil)
        
        XCTAssertTrue(responseData != nil)
    }
    
    func test_Comments_FlagCommentAsDeleted(){
        
        let request = CommentsService.FlagCommentAsDeleted()
        request.comment_conversation_id = Constants.commentConversationId
        request.comment_comment_id = Constants.commentCommentId
        request.userid = Constants.commentOwnerId
        request.deleted = false // set to true to flag the comment and set to false to restore the flag

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?
        
        services.ams.commentsServices(request) {response in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            expectation.fulfill()
        }
        waitForExpectations(timeout: TIMEOUT, handler: nil)
        
        XCTAssertTrue(responseData != nil)
    }
    
    func test_Comments_DeleteCommentPermanent(){
        test_Comments_CreateAndPublishData()
        let request = CommentsService.DeleteCommentPermanent()
        request.comment_conversation_id = Constants.commentConversationId
        request.comment_comment_id = TEST_COMMENT_ID
        request.userid =  "userid_georgew"//Constants.commentOwnerId
        
        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?
        
        services.ams.commentsServices(request) {response in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            expectation.fulfill()
        }
        waitForExpectations(timeout: TIMEOUT, handler: nil)
        
        XCTAssertTrue(responseData != nil)
    }
    
    func test_Comments_UpdateComment(){
        
        let request = CommentsService.UpdateComment()
        request.comment_conversation_id = Constants.commentConversationId
        request.comment_comment_id = Constants.commentCommentId
        request.userid =  Constants.commentOwnerId//"userid_georgew"
        request.body = "comment has been modified from body param"
        

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?
        
        services.ams.commentsServices(request) {response in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            expectation.fulfill()
        }
        waitForExpectations(timeout: TIMEOUT, handler: nil)
        
        XCTAssertTrue(responseData != nil)
    }
    
    func test_Comments_ReactToACommentLike(){
        
        let request = CommentsService.ReactToCommentLike()
        request.comment_conversation_id = Constants.commentConversationId
        request.comment_comment_id = Constants.commentCommentId
        request.userid = "userid_georgew"
        request.reacted = true
        request.reaction = "like"

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?
        
        services.ams.commentsServices(request) {response in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            expectation.fulfill()
        }
        waitForExpectations(timeout: TIMEOUT, handler: nil)
        
        XCTAssertTrue(responseData != nil)
    }
    
    func test_Comments_VoteCommentUp(){
        
        test_Comments_CreateAndPublishData()
        let request = CommentsService.VoteUpOrDownOnComment()
        request.comment_conversation_id = Constants.commentConversationId
        request.comment_comment_id = TEST_COMMENT_ID
        request.userid = "userid_georgew"
        request.vote = "up"

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?
        
        services.ams.commentsServices(request) {response in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            expectation.fulfill()
        }
        waitForExpectations(timeout: TIMEOUT, handler: nil)
        
        XCTAssertTrue(responseData != nil)
    }
    
    func test_Comments_VoteCommentDown(){
        test_Comments_CreateAndPublishData()
        let request = CommentsService.VoteUpOrDownOnComment()
        request.comment_conversation_id = Constants.commentConversationId
        request.comment_comment_id = TEST_COMMENT_ID
        request.userid = "userid_georgew"
        request.vote = "down"

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?
        
        services.ams.commentsServices(request) {response in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            expectation.fulfill()
        }
        waitForExpectations(timeout: TIMEOUT, handler: nil)
        
        XCTAssertTrue(responseData != nil)
    }
    
    func test_Comments_VoteCommentNone(){
        test_Comments_CreateAndPublishData()
        let request = CommentsService.VoteUpOrDownOnComment()
        request.comment_conversation_id = Constants.commentConversationId
        request.comment_comment_id = TEST_COMMENT_ID
        request.userid = "userid_georgew"
        request.vote = "none"

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?
        
        services.ams.commentsServices(request) {response in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            expectation.fulfill()
        }
        waitForExpectations(timeout: TIMEOUT, handler: nil)
        
        XCTAssertTrue(responseData != nil)
    }
    
    func test_Comments_ReportComment(){
        test_Comments_CreateAndPublishData()
        let request = CommentsService.ReportComment()
        request.comment_conversation_id = Constants.commentConversationId
        request.comment_comment_id = TEST_COMMENT_ID
        request.userid = "userid_georgew"
        request.reporttype = "abuse"

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?
        
        services.ams.commentsServices(request) {response in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            expectation.fulfill()
        }
        waitForExpectations(timeout: TIMEOUT, handler: nil)
        
        XCTAssertTrue(responseData != nil)
    }
}
