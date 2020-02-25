import XCTest
import SportsTalk_iOS_SDK

let RESPONSE_PARAMETER_DATA = "data"
let RESPONSE_PARAMETER_MESSAGE = "message"
let RESPONSE_PARAMETER_USERS = "users"

class SportsTalk_iOS_SDKTests: XCTestCase {
    
    let services = Services()
    
    let Expectation_Description = "Testing"
    let TEST_USERID = "093486fcd90c495fa6719321d8e1913a"
    let TEST_HANDLE = "DanielBuobu"
    let TEST_BANNED = true
    let TEST_DESCRIPTION = "Testing"
    let TEST_DISPLAY_NAME = "Daniel Buobu"
    let TEST_PICTURE_URL = URL(string: "www.sampleUrl1.com")
    let TEST_PROFILE_URL = URL(string: "www.sampleUrl2.com")
    let TEST_WEBHOOK_ID = "046282d5e2d249739e0080a4d2a04904"
    let TEST_PURGE_COMMAND = "*purge"
    let TEST_ROOM_NEWEST_EVENT_ID = ""
    var TEST_CHAT_ROOM_ID = "5dd9d5a038a28326ccfe5743" //"5e0ef05238a2831098526cc2"
    let TEST_ROOM_ID_OR_SLUG = "5e0ec9b138a2831098526cac"
    let TEST_CUSTOM_EVENT = ""
    let TEST_REPLY_TO = ""
    let TEST_REACTION = "like"
    let TEST_REACTED = false
    let TEST_CUSTOM_ID = "5e0ec9b138a2831098526cac"
    let TEST_CUSTOM_PAYLOAD = ""
    let TEST_ROOM_ID_OR_LABEL = "5e0ec9b138a2831098526cac"
    let TEST_EVENT_ID = ""
    let TEST_CHAT_MESSAGE_ID = "5e3a9f4838a2830ffc831425"
    let TEST_CURSOR = ""
    let TEST_SLUG = URL(string: "www.sampleUrl2.com")
    let TEST_ENABLEACTIONS = true
    let TEST_ENABLEENTERANDEXIT = false
    let TEST_ROOMISOPEN = false
    let TEST_THROTTLE = 0
    
    let RESPONSE_PARAMETER_DISPLAY_NAME = "displayname"
    let RESPONSE_PARAMETER_HANDLE = "handle"
    let RESPONSE_PARAMETER_PROFILE_URL = "profileurl"
    let RESPONSE_PARAMETER_PICTURE_URL = "pictureurl"

    
    override func setUp() {
//        services.url = URL(string: "http://shaped-entropy-259212.appspot.com/demo/api/v3")
        services.url = URL(string: "http://api-origin.sportstalk247.com/api/v3")
        services.authToken = "vfZSpHsWrkun7Yd_fUJcWAHrNjx6VRpEqMCEP3LJV9Tg"
    }
    
    func test1_UserServices_UpdateUser()
    {
        let createUser = UsersServices.CreateUpdateUser()
        createUser.userid = TEST_USERID
        createUser.handle = TEST_HANDLE
        createUser.displayname = TEST_DISPLAY_NAME
        createUser.pictureurl = TEST_PICTURE_URL
        createUser.profileurl = TEST_PROFILE_URL

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?

        services.ams.usersServices(createUser) { (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(TEST_DISPLAY_NAME, responseData?[RESPONSE_PARAMETER_DISPLAY_NAME] as? String)
        XCTAssertEqual(TEST_HANDLE, responseData?[RESPONSE_PARAMETER_HANDLE] as? String)
        XCTAssertEqual(TEST_PICTURE_URL?.absoluteString, responseData?[RESPONSE_PARAMETER_PICTURE_URL] as? String)
    }

    func test2_UserServices_GetUserDetails()
    {
        let getUserDetail = UsersServices.GetUserDetails()
        getUserDetail.userid = TEST_USERID

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?

        services.ams.usersServices(getUserDetail) { (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(TEST_DISPLAY_NAME, responseData?[RESPONSE_PARAMETER_DISPLAY_NAME] as? String)
        XCTAssertEqual(TEST_HANDLE, responseData?[RESPONSE_PARAMETER_HANDLE] as? String)
        XCTAssertEqual(TEST_PROFILE_URL?.absoluteString, responseData?[RESPONSE_PARAMETER_PROFILE_URL] as? String)
    }

    func test3_UserServices_ListUsers()
    {
        let listUsers = UsersServices.ListUsers()
        listUsers.limit = "2"

        let expectation = self.expectation(description: Expectation_Description)
        var usersData:[[AnyHashable:Any]]?

        services.ams.usersServices(listUsers) { (response) in
            let responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            usersData = responseData?[RESPONSE_PARAMETER_USERS] as? [[AnyHashable:Any]]
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(2, usersData?.count)
    }

    func test4_UserServices_ListUsersMore()
    {
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

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(5, usersData.count)
    }

    func test5_UserServies_ListMessagesByUsers()
    {
        let listMessagesByUser = UsersServices.ListMessagesByUser()
        listMessagesByUser.limit = "4"
        listMessagesByUser.userId = TEST_USERID

        var responseData:[AnyHashable:Any]?
        let expectation = self.expectation(description: Expectation_Description)

        services.ams.usersServices(listMessagesByUser) { (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert((responseData?.count ?? 0) > 0)
    }

    func test6_UserServies_SearchUsersByHandle()
    {
        let searchUsersByHandle = UsersServices.SearchUsersByHandle()
        searchUsersByHandle.handle = TEST_HANDLE

        var users:[[AnyHashable:Any]]?
        let expectation = self.expectation(description: Expectation_Description)

        services.ams.usersServices(searchUsersByHandle) { (response) in
            let responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            users = responseData?[RESPONSE_PARAMETER_USERS] as? [[AnyHashable:Any]]

            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssert((users?.count ?? 0) > 0)
    }

    func test7_UserServies_SearchUsersByName()
    {
        let searchUsersByName = UsersServices.SearchUsersByName()
        searchUsersByName.name = TEST_DISPLAY_NAME

        var users:[[AnyHashable:Any]]?
        let expectation = self.expectation(description: Expectation_Description)

        services.ams.usersServices(searchUsersByName) { (response) in
            let responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            users = responseData?[RESPONSE_PARAMETER_USERS] as? [[AnyHashable:Any]]
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssert((users?.count ?? 0) > 0)
    }

    func test8_UserServies_SearchUsersByUserId()
    {
        let searchUsersByUserId = UsersServices.SearchUsersByUserId()
        searchUsersByUserId.userId = TEST_USERID

        var users:[[AnyHashable:Any]]?
        let expectation = self.expectation(description: Expectation_Description)

        services.ams.usersServices(searchUsersByUserId) { (response) in
            let responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            users = responseData?[RESPONSE_PARAMETER_USERS] as? [[AnyHashable:Any]]

            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssert((users?.count ?? 0) > 0)
    }

    func test9_ModerationServices_BanUser()
    {
        let banUser = ModerationServices.BanUser()
        banUser.userid = TEST_USERID

        let expectation = self.expectation(description: Expectation_Description)
        var responseMessage:String?

        services.ams.moderationServies(banUser){ (response) in
            responseMessage = response[RESPONSE_PARAMETER_MESSAGE] as? String
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertTrue(responseMessage?.contains("not banned") ?? false)
    }

    func test10_ModerationServices_RestoreUser()
    {
        let restoreUser = ModerationServices.RestoreUser()
        restoreUser.userid = TEST_USERID

        let expectation = self.expectation(description: Expectation_Description)
        var responseMessage:String?

        services.ams.moderationServies(restoreUser){ (response) in
            responseMessage = response[RESPONSE_PARAMETER_MESSAGE] as? String
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertTrue(responseMessage?.contains("not banned") ?? false)
    }

    func test12_ModerationServices_DeleteAllEventsInRoom()
    {
        test16_ChatRoomsServices_CreateRoom()
        test21_ChatRoomsServices_JoinRoomAuthenticatedUser()
        
        let deleteAllEventsInRoom = ModerationServices.DeleteAllEventsInRoom()
        deleteAllEventsInRoom.userid = TEST_USERID
        deleteAllEventsInRoom.command = "*deleteallevents zola"
        deleteAllEventsInRoom.chatroomid = TEST_CHAT_ROOM_ID
        
        let expectation = self.expectation(description: Expectation_Description)
        var responseMessage:String?
        
        services.ams.moderationServies(deleteAllEventsInRoom){ (response) in
            responseMessage = response[RESPONSE_PARAMETER_MESSAGE] as? String
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(responseMessage == "Deleted 0 events.")
    }

    func test13_ModerationServices_RemoveMessage()
    {
        let removeMessage = ModerationServices.RemoveMessage()
        removeMessage.chatMessageId = "5e3a9f4838a2830ffc831425"
        removeMessage.chatRoomId = "001864a867604101b29672e904da688a"

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?

        services.ams.moderationServies(removeMessage){ (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            print(response)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertTrue(responseData != nil)
    }

    func test14_ModerationServices_ReportMessage()
    {
        let reportMessage = ModerationServices.ReportMessage()
        reportMessage.chat_room_newest_speech_id = "5e3bf97d38a2831fcc3f045b"
        reportMessage.chatRoomId = "5e3baf6938a2831fcc3f043f"
        reportMessage.userid = "093486fcd90c495fa6719321d8e1913a"

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?

        services.ams.moderationServies(reportMessage){ (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            print(response)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertTrue(responseData != nil)
    }

    func test15_ModerationServices_ApproveMessage()
    {
        let approveMessage = ModerationServices.ApproveMessage()
        approveMessage.chatMessageId = TEST_CHAT_MESSAGE_ID
        approveMessage.chatRoomId = TEST_CHAT_ROOM_ID

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?

        services.ams.moderationServies(approveMessage){ (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertTrue(responseData != nil)
    }

    func test16_ChatRoomsServices_CreateRoom()
    {
        let createRoom = ChatRoomsServices.CreateRoom()
        createRoom.name = TEST_DISPLAY_NAME
        createRoom.slug = TEST_SLUG
        createRoom.description = ""
        createRoom.enableactions = TEST_ENABLEACTIONS
        createRoom.enableenterandexit = TEST_ENABLEENTERANDEXIT
        createRoom.roomisopen = TEST_ROOMISOPEN
        createRoom.userid = TEST_USERID

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?

        services.ams.chatRoomsServices(createRoom){ (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            self.TEST_CHAT_ROOM_ID = (responseData?["id"] as? String) ?? ""
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertTrue(responseData != nil)
    }

    func test17_ChatRoomsServices_UpdateRoom()
    {
        let updateRoom = ChatRoomsServices.UpdateRoom()
        updateRoom.name = TEST_DISPLAY_NAME
        updateRoom.slug = TEST_SLUG
        updateRoom.description = TEST_DESCRIPTION
        updateRoom.enableactions = TEST_ENABLEACTIONS
        updateRoom.enableenterandexit = TEST_ENABLEENTERANDEXIT
        updateRoom.roomisopen = TEST_ROOMISOPEN
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

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertTrue(responseData != nil)
    }

    func test18_ChatRoomsServices_UpdateRoomCloseARoom()
    {
        let updateRoomCloseARoom = ChatRoomsServices.UpdateRoomCloseARoom()
        updateRoomCloseARoom.roomisopen = TEST_ROOMISOPEN
        updateRoomCloseARoom.roomid = TEST_CHAT_ROOM_ID

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?

        services.ams.chatRoomsServices(updateRoomCloseARoom){ (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            print(response)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertTrue(responseData != nil)
    }

    func test19_ChatRoomsServices_ListRooms()
    {
        let listRooms = ChatRoomsServices.ListRooms()

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[[AnyHashable:Any]]?

        services.ams.chatRoomsServices(listRooms){ (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [[AnyHashable:Any]]
            print(response)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertTrue(responseData != nil)
    }

    func test20_ChatRoomsServices_ListRoomParticipants()
    {
        let listRoomParticipants = ChatRoomsServices.ListRoomParticipants()
        listRoomParticipants.cursor = TEST_CURSOR
        listRoomParticipants.roomid = "5dd9d5a038a28326ccfe5743"

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?

        services.ams.chatRoomsServices(listRoomParticipants){ (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            print(response)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertTrue(responseData != nil)
    }

    func test21_ChatRoomsServices_JoinRoomAuthenticatedUser()
    {
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

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertTrue(responseData != nil)
    }

    func test22_ChatRoomsServices_JoinRoomAnonymousUser()
    {
        let joinRoomAnonymousUser = ChatRoomsServices.JoinRoomAnonymousUser()
        joinRoomAnonymousUser.roomid = TEST_CHAT_ROOM_ID

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?

        services.ams.chatRoomsServices(joinRoomAnonymousUser){ (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            print(response)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertTrue(responseData != nil)
    }

    func test23_ChatRoomsServices_GetUpdates()
    {
        let getUpdates = ChatRoomsServices.GetUpdates()
        getUpdates.roomId = TEST_CHAT_ROOM_ID

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[[AnyHashable:Any]]?

        services.ams.chatRoomsServices(getUpdates){ (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [[AnyHashable:Any]]
            print(response)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertTrue(responseData != nil)
    }

    func test24_ChatRoomsServices_GetUpdatesMore()
    {
        let getUpdatesMore = ChatRoomsServices.GetUpdatesMore()
        getUpdatesMore.roomIdOrLabel = TEST_ROOM_ID_OR_LABEL
        getUpdatesMore.eventid = TEST_EVENT_ID

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?

        services.ams.chatRoomsServices(getUpdatesMore){ (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertTrue(responseData != nil)
    }

    func test25_ChatRoomsServices_ExecuteChatCommand()
    {
        test16_ChatRoomsServices_CreateRoom()
        test21_ChatRoomsServices_JoinRoomAuthenticatedUser()

        let executeChatCommand = ChatRoomsServices.ExecuteChatCommand()
        executeChatCommand.roomId = TEST_CHAT_ROOM_ID
        executeChatCommand.command = "Hello test command"
        executeChatCommand.userid = TEST_USERID

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?

        services.ams.chatRoomsServices(executeChatCommand){ (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertTrue(responseData != nil)
    }

    func test26_ChatRoomsServices_ExecuteDanceAction()
    {
        test16_ChatRoomsServices_CreateRoom()
        test21_ChatRoomsServices_JoinRoomAuthenticatedUser()
        
        let executeDanceAction = ChatRoomsServices.ExecuteDanceAction()
        executeDanceAction.roomId = TEST_CHAT_ROOM_ID
        executeDanceAction.command = "/high5 georgew"
        executeDanceAction.userid = TEST_USERID
        executeDanceAction.customtype = TEST_CUSTOM_EVENT
        executeDanceAction.customid = TEST_CUSTOM_ID
        executeDanceAction.custompayload = TEST_CUSTOM_PAYLOAD

        let expectation = self.expectation(description: Expectation_Description)
        var responseMessage:String = ""

        services.ams.chatRoomsServices(executeDanceAction){ (response) in
            responseMessage = (response[RESPONSE_PARAMETER_MESSAGE] as? String) ?? ""
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertTrue(!responseMessage.isEmpty)
    }

    func test27_ChatRoomsServices_ReplyToAMessage()
    {
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

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertTrue(responseData != nil)
    }

    func test28_ChatRoomsServices_ExecuteAdminCommand()
    {
        test16_ChatRoomsServices_CreateRoom()
        test21_ChatRoomsServices_JoinRoomAuthenticatedUser()

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

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertTrue(responseMessage != nil)
    }

    func test29_ChatRoomsServices_ExitRoom()
    {
        test16_ChatRoomsServices_CreateRoom()
        test21_ChatRoomsServices_JoinRoomAuthenticatedUser()

        let exitRoom = ChatRoomsServices.ExitRoom()
        exitRoom.roomId = TEST_CHAT_ROOM_ID
        exitRoom.userid = TEST_USERID

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?

        services.ams.chatRoomsServices(exitRoom){ (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertTrue(responseData != nil)
    }

    func test30_ChatRoomsServices_GetRoomDetails()
    {
        let getRoomDetails = ChatRoomsServices.GetRoomDetails()
        getRoomDetails.roomIdOrSlug = TEST_ROOM_ID_OR_SLUG

        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?

        services.ams.chatRoomsServices(getRoomDetails){ (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertTrue(responseData != nil)
    }
}
