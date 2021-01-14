import XCTest
import SportsTalk247

struct Config {
    static let url = URL(string: "https://qa-talkapi.sportstalk247.com/api/v3/")
    static let appId = "5ebbe03d5617e00de4b044c2"
    static let authToken = "lKXXRQ0QA0W7ySVNQa0Bhg8yDKrBMCfkGnfpsApZin-g"
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
    
    var dummyNotification: UserNotification? { didSet { print("UserNotification saved: \(dummyNotification?.id)") } }
        
    override func setUpWithError() throws {
        SportsTalkSDK.shared.debugMode = true
        createUpdateUser()
        createUpdateOtherUser()
    }
}

extension UserClientTests {
    func test_UserServices_UpdateUser() {
        let request = UserRequest.CreateUpdateUser()
        request.userid = "9940A8C9-2332-4824-B628-48390F367D29"
        request.handle = "GeorgeWASHING"
        request.displayname = "George Washing"
        request.pictureurl = URL(string: "http://www.thepresidentshalloffame.com/media/reviews/photos/original/a9/c7/a6/44-1-george-washington-18-1549729902.jpg")
        request.profileurl = URL(string: "http://www.thepresidentshalloffame.com/1-george-washington")

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
        
        let request = UserRequest.DeleteUser()
        request.userid = otherUser?.userid
        
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
        
        let request = UserRequest.GetUserDetails()
        request.userid = dummyUser?.userid

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
        let request = UserRequest.ListUsers()
        request.limit = "5"

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
        
        let request = UserRequest.SetBanStatus()
        request.userid = dummyUser?.userid
        request.banned = true
        
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
        
        let request = UserRequest.GloballyPurgeUserContent()
        request.userid = dummyUser?.userid
        request.banned = true
        
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
        
        let request = UserRequest.SetBanStatus()
        request.userid = dummyUser?.userid
        request.banned = false
        
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
        if self.dummyUser == nil {
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
    
    func test_UserServices_ReportUser() {
        if self.otherUser == nil {
            createUpdateOtherUser()
        }
        
        let request = UserRequest.ReportUser()
        request.userid = otherUser?.userid
        request.reporttype = "abuse"
        
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
        
        let request = UserRequest.SetShadowBanStatus()
        request.userid = dummyUser!.userid
        request.shadowban = !(dummyUser?.shadowbanned ?? false)
        request.expireseconds = 60
        
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
        
        let request = UserRequest.ListUserNotifications()
        request.userid = dummyUser!.userid
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        
        client.listUserNotifications(request) { (code, message, _, response) in
            print(message ?? "")
            receivedCode = code
            self.dummyNotification = response?.notifications?.filter{ ($0.isread ?? false) == false }.first
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssert(receivedCode == 200)
    }
    
    func test_UserServices_SetNotificationAsRead() {
        if self.dummyUser == nil {
            test_UserServices_UpdateUser()
        }
        
        if self.dummyNotification == nil {
            test_UserServices_ListUserNotification()
        }
        
        let request = UserRequest.SetUserNotificationAsRead()
        request.userid = dummyUser!.userid
        request.notificationid = dummyNotification?.id
        
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
}

// MARK: - Convenience
extension UserClientTests {
    private func createUpdateUser() {
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        
        let request = UserRequest.CreateUpdateUser()
        request.userid = "9940A8C9-2332-4824-B628-48390F367D29"
        request.handle = "GeorgeWASHING"
        request.displayname = "George Washing"
        request.pictureurl = URL(string: "http://www.thepresidentshalloffame.com/media/reviews/photos/original/a9/c7/a6/44-1-george-washington-18-1549729902.jpg")
        request.profileurl = URL(string: "http://www.thepresidentshalloffame.com/1-george-washington")
        
        client.createOrUpdateUser(request) { (code, message, kind, user) in
            self.dummyUser = user
            expectation.fulfill()
        }
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
    }
    
    private func createUpdateOtherUser() {
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        
        let request = UserRequest.CreateUpdateUser()
        request.userid = "9940A8C9-2332-4824-B628-48390F367D30"
        request.handle = "JohnWICK"
        request.displayname = "John Wick"
        request.pictureurl = nil
        request.profileurl = nil
        
        client.createOrUpdateUser(request) { (code, message, kind, user) in
            self.otherUser = user
            expectation.fulfill()
        }
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
    }
}
