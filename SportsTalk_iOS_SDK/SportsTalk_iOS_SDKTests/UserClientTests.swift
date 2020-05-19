//
//  UserClientTests.swift
//  SportsTalk_iOS_SDKTests
//
//  Created by Angelo Lesano on 5/19/20.
//  Copyright © 2020 krishna41. All rights reserved.
//

import XCTest
import SportsTalk_iOS_SDK

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
}

extension UserClientTests {
    func test_UserServices_UpdateUser() {
        let request = UsersServices.CreateUpdateUser()
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
        let request = UsersServices.DeleteUser()
        request.userid = dummyUser?.userid
        print("user id \(String(describing: dummyUser?.userid))")
        
        let expectation = self.expectation(description: Constants.Expectation_Description)
        var receivedCode: Int?

        client.deleteUser(request) { (code, message, _, response) in
            print(message!)
            print("userId: \(String(describing: response?.user?.userid))")
            
            receivedCode = code
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)

        XCTAssertTrue(receivedCode == 200)
    }

    func test_UserServices_GetUserDetails() {
        test_UserServices_UpdateUser()
        let request = UsersServices.GetUserDetails()
        request.userid = dummyUser?.userid

        let expectation = self.expectation(description: Constants.Expectation_Description)
        var receivedUser: User?
        var receivedCode: Int?
        
        client.getUserDetails(request) { (code, message, _, user) in
            print(message!)
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
        let request = UsersServices.ListUsers()
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
        let request = UsersServices.BanUser()
        request.userid = dummyUser?.userid
        let expectation = self.expectation(description: Constants.Expectation_Description)
        var banned: Bool?

        client.banUser(request) { (code, message, _, user) in
            print(message!)
            banned = user?.banned
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(banned ?? false)
    }

    func test_UserServices_RestoreUser()
    {
        test_UserServices_BanUser()
        let request = UsersServices.RestoreUser()
        request.userid = dummyUser?.userid

        let expectation = self.expectation(description: Constants.Expectation_Description)
        var banned: Bool? = false
        
        client.restoreUser(request) { (code, message, _, user) in
            print(message!)
            banned = user?.banned
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(!(banned ?? true))
    }

    func test_UserServices_SearchUsersByHandle() {
        test_UserServices_UpdateUser()
        let request = UsersServices.SearchUsersByHandle()
        request.handle = dummyUser?.handle ?? "Sam"
        request.limit = "5"

        let expectation = self.expectation(description: Constants.Expectation_Description)
        var receivedUsers: [User]?
        var receivedCode: Int?
        
        client.searchByHandle(request) { (code, message, _, response) in
            print(message!)
            print("found \(String(describing: response?.users.count))")
            
            receivedUsers = response?.users
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssert((receivedUsers?.count ?? 0) > 0)
        XCTAssert(receivedCode == 200)
    }

    func test_UserServices_SearchUsersByName() {
        test_UserServices_UpdateUser()
        let request = UsersServices.SearchUsersByName()
        request.name = dummyUser?.displayname ?? "Sam"

        let expectation = self.expectation(description: Constants.Expectation_Description)
        var receivedUsers: [User]?
        var receivedCode: Int?
        
        client.searchByName(request) { (code, message, _, response) in
            print(message!)
            print("found \(String(describing: response?.users.count))")
            receivedUsers = response?.users
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssert((receivedUsers?.count ?? 0) > 0)
        XCTAssert(receivedCode == 200)
    }

    func test_UserServices_SearchUsersByUserId() {
        test_UserServices_UpdateUser()
        let request = UsersServices.SearchUsersByUserId()
        request.userId = dummyUser?.userid

        let expectation = self.expectation(description: Constants.Expectation_Description)
        var receivedUsers: [User]?
        var receivedCode: Int?
        
        client.searchByUserId(request) { (code, message, _, response) in
            print(message!)
            print("found \(String(describing: response?.users.count))")
            receivedUsers = response?.users
            receivedCode = code
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssert((receivedUsers?.count ?? 0) > 0)
        XCTAssert(receivedCode == 200)
    }
}
