import XCTest
import SportsTalk247

struct Config {
    static let url = URL(string: "https://qa-talkapi.sportstalk247.com/api/v3/")
    static let appId = "5ebbe03d5617e00de4b044c2"
    static let authToken = "lKXXRQ0QA0W7ySVNQa0Bhg8yDKrBMCfkGnfpsApZin-g"
    static let TIMEOUT: Double = 10
}

struct Constants {
    static let commentConversationId = "Demo_Conversation"
    static let commentCommentId = "5e92b15d38a28d0b64536887"
    static let commentOwnerId = "brenn"
    static let customId = "/articles/2020-03-01/article1/something-very-important-happened"
    static let propertyId = "sportstalk247.com/apidemo"
    static let Expectation_Description = "Testing"
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
        
    override func setUpWithError() throws {
        SportsTalkSDK.shared.debugMode = true
    }
}

extension UserClientTests {
    func test_UserServices_UpdateUser() {
        let request = UserRequest.CreateUpdateUser()
        request.userid =  UUID().uuidString
        request.handle = "Sam"
        request.displayname = "Sam"
        request.pictureurl = URL(string: dummyUser?.pictureurl ?? "")
        request.profileurl = URL(string: dummyUser?.profileurl ?? "")

        let expectation = self.expectation(description: Constants.Expectation_Description)
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
        test_UserServices_UpdateUser()
        let request = UserRequest.DeleteUser()
        request.userid = dummyUser?.userid
        print("user id \(String(describing: dummyUser?.userid))")
        
        let expectation = self.expectation(description: Constants.Expectation_Description)
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
        test_UserServices_UpdateUser()
        let request = UserRequest.GetUserDetails()
        request.userid = dummyUser?.userid

        let expectation = self.expectation(description: Constants.Expectation_Description)
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
        test_UserServices_UpdateUser()
        test_UserServices_UpdateUser()
        test_UserServices_UpdateUser()
        test_UserServices_UpdateUser()
        test_UserServices_UpdateUser()
        let request = UserRequest.ListUsers()
        request.limit = "5"

        let expectation = self.expectation(description: Constants.Expectation_Description)
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
        test_UserServices_UpdateUser()
        let request = UserRequest.setBanStatus()
        request.userid = dummyUser?.userid
        request.banned = true
        
        let expectation = self.expectation(description: Constants.Expectation_Description)
        var banned: Bool?

        client.setBanStatus(request) { (code, message, _, user) in
            print(message ?? "")
            banned = user?.banned
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(banned == true)
    }

    func test_UserServices_RestoreUser()
    {
        test_UserServices_UpdateUser()
        let request = UserRequest.setBanStatus()
        request.userid = dummyUser?.userid
        request.banned = false
        
        let expectation = self.expectation(description: Constants.Expectation_Description)
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
        test_UserServices_UpdateUser()
        let request = UserRequest.SearchUser()
        request.handle = dummyUser?.handle ?? "Sam"
        request.limit = 5
        
        let expectation = self.expectation(description: Constants.Expectation_Description)
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
        XCTAssert((receivedUsers?.count ?? 0) > 0)
        XCTAssert(receivedCode == 200)
    }
}
