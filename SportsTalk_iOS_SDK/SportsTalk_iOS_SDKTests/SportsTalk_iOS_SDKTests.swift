import XCTest
import SportsTalk_iOS_SDK

let RESPONSE_PARAMETER_DATA = "data"
let RESPONSE_PARAMETER_USERS = "users"

class SportsTalk_iOS_SDKTests: XCTestCase {

    let services = Services()
    
    let Expectation_Description = "Testing"
    let TEST_USERID = "046282d5e2d249739e0080a4d2a04904"
    let TEST_HANDLE = "Sarah"
    let TEST_BANNED = true
    let TEST_DISPLAY_NAME = "Test User"
    let TEST_PICTURE_URL = URL(string: "www.sampleUrl1.com")
    let TEST_PROFILE_URL = URL(string: "www.sampleUrl1.com")
    let TEST_WEBHOOK_ID = "046282d5e2d249739e0080a4d2a04904"
    
    let RESPONSE_PARAMETER_DISPLAY_NAME = "displayname"
    let RESPONSE_PARAMETER_PROFILE_URL = "profileurl"
    let RESPONSE_PARAMETER_PICTURE_URL = "pictureurl"


    override func setUp() {
//        services.url = URL(string: "http://shaped-entropy-259212.appspot.com/demo/api/v3")
        services.url = URL(string: "http://api-origin.sportstalk247.com/api/v3")
        services.authToken = "vfZSpHsWrkun7Yd_fUJcWAHrNjx6VRpEqMCEP3LJV9Tg"
    }

    func test_UserServices_UpdateUser()
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
        XCTAssertEqual(TEST_PROFILE_URL?.absoluteString, responseData?[RESPONSE_PARAMETER_PROFILE_URL] as? String)
        XCTAssertEqual(TEST_PICTURE_URL?.absoluteString, responseData?[RESPONSE_PARAMETER_PICTURE_URL] as? String)
    }
    
    func test_UserServices_GetUserDetails()
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
        XCTAssertEqual(TEST_PROFILE_URL?.absoluteString, responseData?[RESPONSE_PARAMETER_PROFILE_URL] as? String)
        XCTAssertEqual(TEST_PICTURE_URL?.absoluteString, responseData?[RESPONSE_PARAMETER_PICTURE_URL] as? String)
    }
    
    func test_UserServices_ListUsers()
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
    
    func test_UserServices_ListUsersMore()
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
    
    func test_UserServies_ListMessagesByUsers()
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
    
    func test_UserServies_SearchUsersByHandle()
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
    
    func test_UserServies_SearchUsersByName()
    {
        let searchUsersByName = UsersServices.SearchUsersByName()
        searchUsersByName.name = name
        
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

    func test_UserServies_SearchUsersByUserId()
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

    func test_UserServies_CreateWebhooksServices()
    {
        let createReplaceWebhook = WebhooksServices.CreateReplaceWebhook()
        createReplaceWebhook.label = "Webhook Demonstration"
        createReplaceWebhook.url = URL(string: "http://shaped-entropy-259212.appspot.com")
        createReplaceWebhook.enabled = false
        createReplaceWebhook.type = "prepublish"
        createReplaceWebhook.events = ["exit", "roomopened", "roomclosed", "purge"]
        
        
        var users:[[AnyHashable:Any]]?
        let expectation = self.expectation(description: Expectation_Description)
        
        services.ams.webhooksServices(createReplaceWebhook, completionHandler: { (response) in
            let responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            users = responseData?[RESPONSE_PARAMETER_USERS] as? [[AnyHashable:Any]]

            expectation.fulfill()
        })
        
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssert((users?.count ?? 0) > 0)
    }

    func test_UserServies_ListWebhooksServices()
    {
        let listWebhooks = WebhooksServices.ListWebhooks()
        
        var webhooks:[[AnyHashable:Any]]?
        let expectation = self.expectation(description: Expectation_Description)
        
        services.ams.webhooksServices(listWebhooks, completionHandler: { (response) in
            let responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            webhooks = responseData?["webhooks"] as? [[AnyHashable:Any]]
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(webhooks != nil)
      }

    func test_UserServies_UpdateWebhooksServices()
    {
        let updateWebhook = WebhooksServices.UpdateWebhook()
        updateWebhook.webhookId = TEST_WEBHOOK_ID
        updateWebhook.label = "Webhook Demonstration"
        updateWebhook.url = URL(string: "http://shaped-entropy-259212.appspot.com")
        updateWebhook.enabled = false
        updateWebhook.type = "prepublish"
        updateWebhook.events = ["exit", "roomopened", "roomclosed", "purge"]
        
        
        var responseData:[[AnyHashable:Any]]?
        let expectation = self.expectation(description: Expectation_Description)
        
        services.ams.webhooksServices(updateWebhook, completionHandler: { (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [[AnyHashable : Any]]
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        
        //    XCTAssert(responseData != nil)
    }
    
    func test_UserServies_DeleteWebhooksServices()
    {
        let deleteWebhooks = WebhooksServices.DeleteWebhook()
        
        deleteWebhooks.webhookId = TEST_WEBHOOK_ID
        
        var responseData:[[AnyHashable:Any]]?
        let expectation = self.expectation(description: Expectation_Description)
        
        services.ams.webhooksServices(deleteWebhooks, completionHandler: { (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [[AnyHashable:Any]]
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        
        //  XCTAssertTrue(webhooks != nil)
    }
    
    func test_ModerationServices_BanUser()
    {
        let banUser = ModerationServices.BanUser()
        banUser.userid = TEST_USERID
        banUser.banned = TEST_BANNED
        
        let expectation = self.expectation(description: Expectation_Description)
        var responseData:[AnyHashable:Any]?
        
        services.ams.moderationServies(banUser){ (response) in
            responseData = response[RESPONSE_PARAMETER_DATA] as? [AnyHashable:Any]
            print(response)
            expectation.fulfill()
        }
                
        waitForExpectations(timeout: 5, handler: nil)
        
//        XCTAssertEqual(TEST_DISPLAY_NAME, responseData?[RESPONSE_PARAMETER_DISPLAY_NAME] as? String)
//        XCTAssertEqual(TEST_PROFILE_URL?.absoluteString, responseData?[RESPONSE_PARAMETER_PROFILE_URL] as? String)
//        XCTAssertEqual(TEST_PICTURE_URL?.absoluteString, responseData?[RESPONSE_PARAMETER_PICTURE_URL] as? String)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
