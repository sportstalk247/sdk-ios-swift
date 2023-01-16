//
//  CommentClientTests.swift
//  SportsTalk247
//
//  Created by Lawrence Cendana on 1/15/23.
//  Copyright © 2023 krishna41. All rights reserved.
//

import XCTest
import SportsTalk247

class CommentClientTests: XCTestCase {
    let config = ClientConfig(appId: Config.appId, authToken: Config.authToken, endpoint: Config.url)
    lazy var commentClient: CommentClient = {
       return CommentClient(config: config)
    }()

    lazy var userClient: UserClient = {
        return UserClient(config: config)
    }()

    var dummyUser: User?
    var dummyConversations: [Conversation] = []
    var dummyComments: [Comment] = []

    override func setUpWithError() throws {
        SportsTalkSDK.shared.debugMode = true
    }

    override func tearDown() {
        deleteTestUser()
        deleteTestConversations()
    }

}

extension CommentClientTests {
    /// TODO:: Write Unit Test Cases
    func test_CreateConversation() {
        let request = CommentRequest.CreateUpdateConversation(
            conversationid: "unit-test\(Int64(Date().timeIntervalSince1970))",
            property: "sportstalk247.com/unittest1",
            moderation: "post"
        )
        request.enableprofanityfilter = false
        request.title = "Sample Conversation 1"
        request.open = true
        request.customid = "test-custom-convo-id1"

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        var createdConversation: Conversation?

        commentClient.createOrUpdateConversation(request) { (code, message, _, data) in
            print(message ?? "")
            receivedCode = code
            createdConversation = data
            if let data {
                self.dummyConversations.append(data)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(createdConversation != nil)
    }
    
    func test_GetConversation() {
        createTestConversation(
            conversationid: "unit-test\(Int64(Date().timeIntervalSince1970))",
            property: "sportstalk247.com/unittest1",
            moderation: "post",
            title: "Sample Conversation 1",
            open: true,
            customid: "test-custom-convo-id\(Int64(Date().timeIntervalSince1970))"
        )
        
        let createdConversation = dummyConversations.first
        let request = CommentRequest.GetConversationById(conversationid: createdConversation!.conversationid!)
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        var getConversation: Conversation?
        
        commentClient.getConversation(request) { (code, message, _, data) in
            print(message ?? "")
            receivedCode = code
            getConversation = data
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(getConversation == createdConversation)
    }
    
    func test_GetConversationByCustomID() {
        let customid = "test-custom-convo-id\(Int64(Date().timeIntervalSince1970))"
        createTestConversation(
            conversationid: "unit-test\(Int64(Date().timeIntervalSince1970))",
            property: "sportstalk247.com/unittest1",
            moderation: "post",
            title: "Sample Conversation 1",
            open: true,
            customid: customid
        )
        
        let createdConversation = dummyConversations.first
        let request = CommentRequest.FindConversationByIdCustomId(customid: customid)
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        var getConversationByCustomId: Conversation?
        
        commentClient.getConversationByCustomId(request) { (code, message, _, data) in
            print(message ?? "")
            receivedCode = code
            getConversationByCustomId = data
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(getConversationByCustomId == createdConversation)
    }
    
    func test_ListConversations() {
        createTestConversation(
            conversationid: "unit-test\(Int64(Date().timeIntervalSince1970))",
            property: "sportstalk247.com/unittest1",
            moderation: "post",
            title: "Sample Conversation 1",
            open: true,
            customid: "test-custom-convo-id\(Int64(Date().timeIntervalSince1970))"
        )
        createTestConversation(
            conversationid: "unit-test\(Int64(Date().timeIntervalSince1970))",
            property: "sportstalk247.com/unittest1",
            moderation: "post",
            title: "Sample Conversation 1",
            open: true,
            customid: "test-custom-convo-id\(Int64(Date().timeIntervalSince1970))"
        )
        
        let createdConversation1 = dummyConversations.first!
        let createdConversation2 = dummyConversations.last!
        let request = CommentRequest.ListConversations()
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        var listConversations: [Conversation] = []
        
        commentClient.listConversations(request) { (code, message, _, data) in
            print(message ?? "")
            receivedCode = code
            if let data {
                listConversations.append(contentsOf: data.conversations)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(listConversations.contains(createdConversation1))
        XCTAssertTrue(listConversations.contains(createdConversation2))
    }
    
    func test_BatchGetConversationDetails() {
        createTestConversation(
            conversationid: "unit-test\(Int64(Date().timeIntervalSince1970))",
            property: "sportstalk247.com/unittest1",
            moderation: "post",
            title: "Sample Conversation 1",
            open: true,
            customid: "test-custom-convo-id\(Int64(Date().timeIntervalSince1970))"
        )
        createTestConversation(
            conversationid: "unit-test\(Int64(Date().timeIntervalSince1970))",
            property: "sportstalk247.com/unittest1",
            moderation: "post",
            title: "Sample Conversation 1",
            open: true,
            customid: "test-custom-convo-id\(Int64(Date().timeIntervalSince1970))"
        )
        
        let createdConversation1 = dummyConversations.first!
        let createdConversation2 = dummyConversations.last!
        let request = CommentRequest.GetBatchConversationDetails(
            ids: [createdConversation1.conversationid!, createdConversation2.conversationid!]
        )
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        var batchGetConversationDetailsResponse: BatchGetConversationDetailsResponse?
        
        commentClient.batchGetConversationDetails(request) { (code, message, _, data) in
            print(message ?? "")
            receivedCode = code
            if let data {
                batchGetConversationDetailsResponse = data
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(batchGetConversationDetailsResponse!.itemcount == 2)
        XCTAssertTrue(batchGetConversationDetailsResponse!.conversations.contains(createdConversation1))
        XCTAssertTrue(batchGetConversationDetailsResponse!.conversations.contains(createdConversation2))
        
    }
    
    func test_ReactToConversationTopic() {
        createTestUser()
        let createdUser = self.dummyUser!
        
        createTestConversation(
            conversationid: "unit-test\(Int64(Date().timeIntervalSince1970))",
            property: "sportstalk247.com/unittest1",
            moderation: "post",
            title: "Sample Conversation 1",
            open: true,
            customid: "test-custom-convo-id\(Int64(Date().timeIntervalSince1970))"
        )
        let createdConversation = dummyConversations.first!
        
        let request = CommentRequest.ReactToConversationTopic(
            conversationid: createdConversation.conversationid!,
            userid: createdUser.userid!,
            reaction: "like",
            reacted: true
        )
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        var reactedConversation: Conversation?
        
        commentClient.reactToConversationTopic(request) { (code, message, _, data) in
            print(message ?? "")
            receivedCode = code
            reactedConversation = data
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(reactedConversation != nil)
        XCTAssertTrue(reactedConversation?.reactions != nil)
        XCTAssertTrue(reactedConversation?.reactions?.contains { $0.type == "like" && $0.users.contains { user in user.userid == createdUser.userid } } == true)
    }
    
    func test_CreateComment() {
        createTestUser()
        let createdUser = self.dummyUser!
        
        createTestConversation(
            conversationid: "unit-test\(Int64(Date().timeIntervalSince1970))",
            property: "sportstalk247.com/unittest1",
            moderation: "post",
            title: "Sample Conversation 1",
            open: true,
            customid: "test-custom-convo-id\(Int64(Date().timeIntervalSince1970))"
        )
        let createdConversation = dummyConversations.first!
        
        let commentBody = "Sample Comment \(Int(Date().timeIntervalSince1970))"
        let request = CommentRequest.CreateComment(
            conversationid: createdConversation.conversationid!,
            userid: createdUser.userid!,
            body: commentBody
        )
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        var createdComment: Comment?
        
        commentClient.createComment(request) { (code, message, _, data) in
            print(message ?? "")
            receivedCode = code
            createdComment = data
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(createdComment != nil)
        XCTAssertTrue(createdComment?.conversationid == createdConversation.conversationid)
        XCTAssertTrue(createdComment?.userid == createdUser.userid)
        XCTAssertTrue(createdComment?.body == commentBody)
    }
    
    func test_ReplyToComment() {
        createTestUser()
        let createdUser = self.dummyUser!
        
        createTestConversation(
            conversationid: "unit-test\(Int64(Date().timeIntervalSince1970))",
            property: "sportstalk247.com/unittest1",
            moderation: "post",
            title: "Sample Conversation 1",
            open: true,
            customid: "test-custom-convo-id\(Int64(Date().timeIntervalSince1970))"
        )
        let createdConversation = dummyConversations.first!
        
        createTestComment(
            conversationid: createdConversation.conversationid!,
            userid: createdUser.userid!,
            body: "Sample Comment 1"
        )
        let rootComment = dummyComments.first!
        
        let replyCommentBody = "Sample REPLY Comment \(Int(Date().timeIntervalSince1970))"
        let request = CommentRequest.ReplyToComment(
            conversationid: createdConversation.conversationid!,
            replytocommentid: rootComment.id!,
            userid: createdUser.userid!,
            body: replyCommentBody
        )
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        var replyToComment: Comment?
        
        commentClient.replyToComment(request) { (code, message, _, data) in
            print(message ?? "")
            receivedCode = code
            replyToComment = data
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(replyToComment != nil)
        XCTAssertTrue(replyToComment?.conversationid == createdConversation.conversationid)
        XCTAssertTrue(replyToComment?.userid == createdUser.userid)
        XCTAssertTrue(replyToComment?.body == replyCommentBody)
        XCTAssertTrue(replyToComment?.parentid == rootComment.id)
        XCTAssertTrue(replyToComment?.hierarchy?.contains { $0 == rootComment.id } == true)
    }
    
    func test_ListCommentReplies() {
        createTestUser()
        let createdUser = self.dummyUser!
        
        createTestConversation(
            conversationid: "unit-test\(Int64(Date().timeIntervalSince1970))",
            property: "sportstalk247.com/unittest1",
            moderation: "post",
            title: "Sample Conversation 1",
            open: true,
            customid: "test-custom-convo-id\(Int64(Date().timeIntervalSince1970))"
        )
        let createdConversation = dummyConversations.first!
        
        createTestComment(
            conversationid: createdConversation.conversationid!,
            userid: createdUser.userid!,
            body: "Sample Comment 1"
        )
        let rootComment = dummyComments.first!
        
        let commentReplyBody1 = "Sample Comment Reply 1"
        let commentReplyBody2 = "Sample Comment Reply 2"
        let commentReplyBody3 = "Sample Comment Reply 3"
        var commentReplies: [Comment] = []
        for replyBody in [commentReplyBody1, commentReplyBody2, commentReplyBody3] {
            createTestReplyComment(
                conversationid: createdConversation.conversationid!,
                replytocommentid: rootComment.id!,
                userid: createdUser.userid!,
                body: replyBody
            )
        }
        commentReplies.append(contentsOf: dummyComments.filter { $0.id != rootComment.id })
        
        let request = CommentRequest.ListCommentReplies(
            conversationid: createdConversation.conversationid!,
            commentid: rootComment.id!
        )
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        var listCommentReplies: ListCommentsResponse?
        
        commentClient.listCommentReplies(request) { (code, message, _, data) in
            print(message ?? "")
            receivedCode = code
            listCommentReplies = data
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(listCommentReplies != nil)
        XCTAssertTrue(listCommentReplies?.itemcount == Int64(commentReplies.count))
        XCTAssertTrue(listCommentReplies?.conversation == createdConversation)
        XCTAssertTrue(listCommentReplies?.comments == commentReplies)
        
    }
    
    func test_GetComment() {
        createTestUser()
        let createdUser = self.dummyUser!
        
        createTestConversation(
            conversationid: "unit-test\(Int64(Date().timeIntervalSince1970))",
            property: "sportstalk247.com/unittest1",
            moderation: "post",
            title: "Sample Conversation 1",
            open: true,
            customid: "test-custom-convo-id\(Int64(Date().timeIntervalSince1970))"
        )
        let createdConversation = dummyConversations.first!
        
        createTestComment(
            conversationid: createdConversation.conversationid!,
            userid: createdUser.userid!,
            body: "Sample Comment 1"
        )
        let createdComment = dummyComments.first!
        
        let request = CommentRequest.GetCommentDetails(
            conversationid: createdConversation.conversationid!,
            commentid: createdComment.id!
        )
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        var getComment: Comment?
        
        commentClient.getComment(request) { (code, message, _, data) in
            print(message ?? "")
            receivedCode = code
            getComment = data
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(getComment != nil)
        XCTAssertTrue(getComment == createdComment)
    }
    
    func test_ListComments() {
        createTestUser()
        let createdUser = self.dummyUser!
        
        createTestConversation(
            conversationid: "unit-test\(Int64(Date().timeIntervalSince1970))",
            property: "sportstalk247.com/unittest1",
            moderation: "post",
            title: "Sample Conversation 1",
            open: true,
            customid: "test-custom-convo-id\(Int64(Date().timeIntervalSince1970))"
        )
        let createdConversation = dummyConversations.first!
        
        let commentBody1 = "Sample Comment Reply 1"
        let commentBody2 = "Sample Comment Reply 2"
        let commentBody3 = "Sample Comment Reply 3"
        var comments: [Comment] = []
        for body in [commentBody1, commentBody2, commentBody3] {
            createTestComment(
                conversationid: createdConversation.conversationid!,
                userid: createdUser.userid!,
                body: body
            )
        }
        comments.append(contentsOf: dummyComments)
        
        let request = CommentRequest.ListComments(
            conversationid: createdConversation.conversationid!
        )
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        var listComments: ListCommentsResponse?
        
        commentClient.listComments(request) { (code, message, _, data) in
            print(message ?? "")
            receivedCode = code
            listComments = data
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(listComments != nil)
        XCTAssertTrue(listComments?.itemcount == Int64(comments.count))
        XCTAssertTrue(listComments?.conversation == createdConversation)
        XCTAssertTrue(listComments?.comments == comments)
        
    }
    
    func test_GetBatchCommentReplies() {
        createTestUser()
        let createdUser = self.dummyUser!
        
        createTestConversation(
            conversationid: "unit-test\(Int64(Date().timeIntervalSince1970))",
            property: "sportstalk247.com/unittest1",
            moderation: "post",
            title: "Sample Conversation 1",
            open: true,
            customid: "test-custom-convo-id\(Int64(Date().timeIntervalSince1970))"
        )
        let createdConversation = dummyConversations.first!
        
        createTestComment(
            conversationid: createdConversation.conversationid!,
            userid: createdUser.userid!,
            body: "Sample Root Comment 1"
        )
        let rootComment1 = dummyComments[0]
        createTestReplyComment(
            conversationid: createdConversation.conversationid!,
            replytocommentid: rootComment1.id!,
            userid: createdUser.userid!,
            body: "Sample REPLY to Root Comment 1"
        )
        let replyComment1 = dummyComments[1]
        createTestComment(
            conversationid: createdConversation.conversationid!,
            userid: createdUser.userid!,
            body: "Sample Root Comment 2"
        )
        let rootComment2 = dummyComments[2]
        createTestReplyComment(
            conversationid: createdConversation.conversationid!,
            replytocommentid: rootComment2.id!,
            userid: createdUser.userid!,
            body: "Sample REPLY to Root Comment 2"
        )
        let replyComment2 = dummyComments[3]
        
        let request = CommentRequest.GetBatchCommentReplies(
            conversationid: createdConversation.conversationid!,
            parentids: [rootComment1.id!, rootComment2.id!]
        )
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        var listCommentRepliesBatchResponse: ListCommentRepliesBatchResponse?
        
        commentClient.listCommentRepliesBatch(request) { (code, message, _, data) in
            print(message ?? "")
            receivedCode = code
            listCommentRepliesBatchResponse = data
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(listCommentRepliesBatchResponse != nil)
        XCTAssertTrue(listCommentRepliesBatchResponse?.repliesgroupedbyparentid.count == 2)
        XCTAssertTrue(listCommentRepliesBatchResponse?.repliesgroupedbyparentid[0].parentid == rootComment1.id)
        XCTAssertTrue(listCommentRepliesBatchResponse?.repliesgroupedbyparentid[0].comments == [replyComment1])
        XCTAssertTrue(listCommentRepliesBatchResponse?.repliesgroupedbyparentid[1].parentid == rootComment2.id)
        XCTAssertTrue(listCommentRepliesBatchResponse?.repliesgroupedbyparentid[1].comments == [replyComment2])
        
    }
    
    func test_ReactToComment() {
        createTestUser()
        let createdUser = self.dummyUser!
        
        createTestConversation(
            conversationid: "unit-test\(Int64(Date().timeIntervalSince1970))",
            property: "sportstalk247.com/unittest1",
            moderation: "post",
            title: "Sample Conversation 1",
            open: true,
            customid: "test-custom-convo-id\(Int64(Date().timeIntervalSince1970))"
        )
        let createdConversation = dummyConversations.first!
        
        createTestComment(
            conversationid: createdConversation.conversationid!,
            userid: createdUser.userid!,
            body: "Sample Comment 1"
        )
        let rootComment = dummyComments.first!
        
        let reaction = "like"
        let request = CommentRequest.ReactToComment(
            conversationid: createdConversation.conversationid!,
            commentid: rootComment.id!,
            userid: createdUser.userid!,
            reaction: reaction,
            reacted: true
        )
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        var reactToComment: Comment?
        
        commentClient.reactToComment(request) { (code, message, _, data) in
            print(message ?? "")
            receivedCode = code
            reactToComment = data
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(reactToComment != nil)
        XCTAssertTrue(reactToComment?.conversationid == createdConversation.conversationid)
        XCTAssertTrue(reactToComment?.userid == createdUser.userid)
        XCTAssertTrue(reactToComment?.reactions != nil)
        XCTAssertTrue(reactToComment?.reactions?.count == 1)
        XCTAssertTrue(reactToComment?.reactions?[0].type == reaction)
        XCTAssertTrue(reactToComment?.reactions?[0].users.contains { $0.userid == createdUser.userid } == true)
    }

    func test_VoteOnComment() {
        createTestUser()
        let createdUser = self.dummyUser!
        
        createTestConversation(
            conversationid: "unit-test\(Int64(Date().timeIntervalSince1970))",
            property: "sportstalk247.com/unittest1",
            moderation: "post",
            title: "Sample Conversation 1",
            open: true,
            customid: "test-custom-convo-id\(Int64(Date().timeIntervalSince1970))"
        )
        let createdConversation = dummyConversations.first!
        
        createTestComment(
            conversationid: createdConversation.conversationid!,
            userid: createdUser.userid!,
            body: "Sample Comment 1"
        )
        let rootComment = dummyComments.first!
        
        let vote = VoteType.up
        let request = CommentRequest.VoteOnComment(
            conversationid: createdConversation.conversationid!,
            commentid: rootComment.id!,
            vote: vote,
            userid: createdUser.userid!
        )
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        var voteOnComment: Comment?
        
        commentClient.voteOnComment(request) { (code, message, _, data) in
            print(message ?? "")
            receivedCode = code
            voteOnComment = data
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(voteOnComment != nil)
        XCTAssertTrue(voteOnComment?.conversationid == createdConversation.conversationid)
        XCTAssertTrue(voteOnComment?.userid == createdUser.userid)
        XCTAssertTrue(voteOnComment?.votecount == 1)
        XCTAssertTrue(voteOnComment?.votes != nil)
        XCTAssertTrue(voteOnComment?.votes?.count == 1)
        XCTAssertTrue(voteOnComment?.votes?.first?.type == vote)
        XCTAssertTrue(voteOnComment?.votes?.first?.users?.contains { $0.userid == createdUser.userid } == true)
    }

    func test_ReportComment() {
        createTestUser()
        let createdUser = self.dummyUser!
        
        createTestConversation(
            conversationid: "unit-test\(Int64(Date().timeIntervalSince1970))",
            property: "sportstalk247.com/unittest1",
            moderation: "post",
            title: "Sample Conversation 1",
            open: true,
            customid: "test-custom-convo-id\(Int64(Date().timeIntervalSince1970))"
        )
        let createdConversation = dummyConversations.first!
        
        createTestComment(
            conversationid: createdConversation.conversationid!,
            userid: createdUser.userid!,
            body: "Sample Comment 1"
        )
        let createdComment = dummyComments.first!
        
        let request = CommentRequest.ReportComment(
            conversationid: createdConversation.conversationid!,
            commentid: createdComment.id!,
            userid: createdUser.userid!,
            reporttype: ReportType.abuse
        )
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        var reportedComment: Comment?
        
        commentClient.reportComment(request) { (code, message, _, data) in
            print(message ?? "")
            receivedCode = code
            reportedComment = data
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(reportedComment != nil)
        XCTAssertTrue(reportedComment?.conversationid == createdConversation.conversationid)
        XCTAssertTrue(reportedComment?.userid == createdUser.userid)
        XCTAssertTrue(reportedComment?.reports?.count == 1)
        XCTAssertTrue(reportedComment?.reports?.first?.userid == createdUser.userid)
        XCTAssertTrue(reportedComment?.reports?.first?.reason == ReportType.abuse.rawValue)
    }

    func test_UpdateComment() {
        createTestUser()
        let createdUser = self.dummyUser!
        
        createTestConversation(
            conversationid: "unit-test\(Int64(Date().timeIntervalSince1970))",
            property: "sportstalk247.com/unittest1",
            moderation: "post",
            title: "Sample Conversation 1",
            open: true,
            customid: "test-custom-convo-id\(Int64(Date().timeIntervalSince1970))"
        )
        let createdConversation = dummyConversations.first!
        
        createTestComment(
            conversationid: createdConversation.conversationid!,
            userid: createdUser.userid!,
            body: "Sample Comment 1"
        )
        let createdComment = dummyComments.first!
        
        let updatedBody = "Sample UPDATED Comment body!!!"
        let request = CommentRequest.UpdateComment(
            conversationid: createdConversation.conversationid!,
            commentid: createdComment.id!,
            userid: createdUser.userid!,
            body: updatedBody
        )
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        var updatedComment: Comment?
        
        commentClient.updateComment(request) { (code, message, _, data) in
            print(message ?? "")
            receivedCode = code
            updatedComment = data
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(updatedComment != nil)
        XCTAssertTrue(updatedComment?.id == createdComment.id)
        XCTAssertTrue(updatedComment?.conversationid == createdConversation.conversationid)
        XCTAssertTrue(updatedComment?.userid == createdUser.userid)
        XCTAssertTrue(updatedComment?.body == updatedBody)
    }

    func test_FlagCommentLogicallyDeleted() {
        createTestUser()
        let createdUser = self.dummyUser!
        
        createTestConversation(
            conversationid: "unit-test\(Int64(Date().timeIntervalSince1970))",
            property: "sportstalk247.com/unittest1",
            moderation: "post",
            title: "Sample Conversation 1",
            open: true,
            customid: "test-custom-convo-id\(Int64(Date().timeIntervalSince1970))"
        )
        let createdConversation = dummyConversations.first!
        
        createTestComment(
            conversationid: createdConversation.conversationid!,
            userid: createdUser.userid!,
            body: "Sample Comment 1"
        )
        let createdComment = dummyComments.first!
        
        let logicallyDeletedBody = "(comment deleted)"
        let request = CommentRequest.FlagCommentLogicallyDeleted(
            conversationid: createdConversation.conversationid!,
            commentid: createdComment.id!,
            userid: createdUser.userid!,
            deleted: true,
            permanentifnoreplies: false
        )
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        var deleteCommentResponse: DeleteCommentResponse?
        
        commentClient.flagCommentLogicallyDeleted(request) { (code, message, _, data) in
            print(message ?? "")
            receivedCode = code
            deleteCommentResponse = data
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(deleteCommentResponse != nil)
        XCTAssertTrue(deleteCommentResponse?.permanentdelete == false)
        XCTAssertTrue(deleteCommentResponse?.comment?.id == createdComment.id)
        XCTAssertTrue(deleteCommentResponse?.comment?.userid == createdComment.userid)
        XCTAssertTrue(deleteCommentResponse?.comment?.body == logicallyDeletedBody)
        XCTAssertTrue(deleteCommentResponse?.comment?.deleted == true)
        
    }

    func test_FlagCommentLogicallyDeleted_permanentifnoreplies() {
        createTestUser()
        let createdUser = self.dummyUser!
        
        createTestConversation(
            conversationid: "unit-test\(Int64(Date().timeIntervalSince1970))",
            property: "sportstalk247.com/unittest1",
            moderation: "post",
            title: "Sample Conversation 1",
            open: true,
            customid: "test-custom-convo-id\(Int64(Date().timeIntervalSince1970))"
        )
        let createdConversation = dummyConversations.first!
        
        createTestComment(
            conversationid: createdConversation.conversationid!,
            userid: createdUser.userid!,
            body: "Sample Comment 1"
        )
        let createdComment = dummyComments.first!
        
        let logicallyDeletedBody = "(comment deleted)"
        let request = CommentRequest.FlagCommentLogicallyDeleted(
            conversationid: createdConversation.conversationid!,
            commentid: createdComment.id!,
            userid: createdUser.userid!,
            deleted: true,
            permanentifnoreplies: true
        )
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        var deleteCommentResponse: DeleteCommentResponse?
        
        commentClient.flagCommentLogicallyDeleted(request) { (code, message, _, data) in
            print(message ?? "")
            receivedCode = code
            deleteCommentResponse = data
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(deleteCommentResponse != nil)
        XCTAssertTrue(deleteCommentResponse?.permanentdelete == true)
        XCTAssertTrue(deleteCommentResponse?.comment?.id == createdComment.id)
        XCTAssertTrue(deleteCommentResponse?.comment?.userid == createdComment.userid)
        XCTAssertTrue(deleteCommentResponse?.comment?.body == logicallyDeletedBody)
        XCTAssertTrue(deleteCommentResponse?.comment?.deleted == true)
    }
    
    func test_DeleteComment() {
        createTestUser()
        let createdUser = self.dummyUser!
        
        createTestConversation(
            conversationid: "unit-test\(Int64(Date().timeIntervalSince1970))",
            property: "sportstalk247.com/unittest1",
            moderation: "post",
            title: "Sample Conversation 1",
            open: true,
            customid: "test-custom-convo-id\(Int64(Date().timeIntervalSince1970))"
        )
        let createdConversation = dummyConversations.first!
        
        createTestComment(
            conversationid: createdConversation.conversationid!,
            userid: createdUser.userid!,
            body: "Sample Comment 1"
        )
        let createdComment = dummyComments.first!
        
        let deletedBody = "(comment deleted)"
        let request = CommentRequest.PermanentlyDeleteComment(
            conversationid: createdConversation.conversationid!,
            commentid: createdComment.id!
        )
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        var deleteCommentResponse: DeleteCommentResponse?
        
        commentClient.permanentlyDeleteComment(request) { (code, message, _, data) in
            print(message ?? "")
            receivedCode = code
            deleteCommentResponse = data
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(deleteCommentResponse != nil)
        XCTAssertTrue(deleteCommentResponse?.permanentdelete == true)
        XCTAssertTrue(deleteCommentResponse?.comment == createdComment)
    }
    
    func test_DeleteConversation() {
        createTestUser()
        let createdUser = self.dummyUser!
        
        createTestConversation(
            conversationid: "unit-test\(Int64(Date().timeIntervalSince1970))",
            property: "sportstalk247.com/unittest1",
            moderation: "post",
            title: "Sample Conversation 1",
            open: true,
            customid: "test-custom-convo-id\(Int64(Date().timeIntervalSince1970))"
        )
        let createdConversation = dummyConversations.first!
        
        let request = CommentRequest.DeleteConversation(
            conversationid: createdConversation.conversationid!
        )
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        var deleteConversationResponse: DeleteConversationResponse?
        
        commentClient.deleteConversation(request) { (code, message, _, data) in
            print(message ?? "")
            receivedCode = code
            deleteConversationResponse = data
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(deleteConversationResponse != nil)
        XCTAssertTrue(deleteConversationResponse?.conversationid == createdConversation.conversationid)
        XCTAssertTrue(deleteConversationResponse?.deletedcomments == 0)
        XCTAssertTrue(deleteConversationResponse?.deletedconversations == 1)
        
    }
    
    func test_ListCommentInModerationQueue() {
        createTestUser()
        let createdUser = self.dummyUser!
        
        createTestConversation(
            conversationid: "unit-test\(Int64(Date().timeIntervalSince1970))",
            property: "sportstalk247.com/unittest1",
            moderation: "pre",
            title: "Sample Moderated Conversation 1",
            open: true,
            customid: "test-custom-convo-id\(Int64(Date().timeIntervalSince1970))"
        )
        let createdConversation = dummyConversations.first!
        
        let commentBody1 = "Sample Comment Reply 1"
        let commentBody2 = "Sample Comment Reply 2"
        let commentBody3 = "Sample Comment Reply 3"
        var commentsInModeration: [Comment] = []
        for body in [commentBody1, commentBody2, commentBody3] {
            createTestComment(
                conversationid: createdConversation.conversationid!,
                userid: createdUser.userid!,
                body: body
            )
        }
        commentsInModeration.append(contentsOf: dummyComments)
        
        let request = CommentModerationRequest.ListCommentsInModerationQueue()
        request.conversationid = createdConversation.conversationid
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        var listCommentsInModeration: ListCommentsResponse?
        
        commentClient.listCommentsInModerationQueue(request) { (code, message, _, data) in
            print(message ?? "")
            receivedCode = code
            listCommentsInModeration = data
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(listCommentsInModeration != nil)
        XCTAssertTrue(listCommentsInModeration?.itemcount == Int64(commentsInModeration.count))
        XCTAssertTrue(listCommentsInModeration?.comments == commentsInModeration)
        
    }
    
    func test_ApproveCommentInModerationQueue_approved() {
        createTestUser()
        let createdUser = self.dummyUser!
        
        createTestConversation(
            conversationid: "unit-test\(Int64(Date().timeIntervalSince1970))",
            property: "sportstalk247.com/unittest1",
            moderation: "post",
            title: "Sample Moderated Conversation 1",
            open: true,
            customid: "test-custom-convo-id\(Int64(Date().timeIntervalSince1970))"
        )
        let createdConversation = dummyConversations.first!
        
        createTestComment(
            conversationid: createdConversation.conversationid!,
            userid: createdUser.userid!,
            body: "Sample Comment 1"
        )
        let comment1 = dummyComments[0]
        createTestReportComment(
            conversationid: createdConversation.conversationid!,
            commentid: comment1.id!,
            userid: createdUser.userid!,
            reporttype: .abuse
        )
        let reportedComment1 = dummyComments[1]
        createTestComment(
            conversationid: createdConversation.conversationid!,
            userid: createdUser.userid!,
            body: "Sample Comment 2"
        )
        
        let request = CommentModerationRequest.ApproveRejectComment(
            commentid: reportedComment1.id!,
            approve: true
        )
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        var approvedComment: Comment?
        
        commentClient.approveMessageInQueue(request) { (code, message, _, data) in
            print(message ?? "")
            receivedCode = code
            approvedComment = data
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(approvedComment != nil)
        XCTAssertTrue(approvedComment?.id == reportedComment1.id)
        XCTAssertTrue(approvedComment?.body == reportedComment1.body)
        XCTAssertTrue(approvedComment?.moderation == "approved")
    }
    
    func test_ApproveCommentInModerationQueue_rejected() {
        createTestUser()
        let createdUser = self.dummyUser!
        
        createTestConversation(
            conversationid: "unit-test\(Int64(Date().timeIntervalSince1970))",
            property: "sportstalk247.com/unittest1",
            moderation: "post",
            title: "Sample Moderated Conversation 1",
            open: true,
            customid: "test-custom-convo-id\(Int64(Date().timeIntervalSince1970))"
        )
        let createdConversation = dummyConversations.first!
        
        createTestComment(
            conversationid: createdConversation.conversationid!,
            userid: createdUser.userid!,
            body: "Sample Comment 1"
        )
        let comment1 = dummyComments[0]
        createTestReportComment(
            conversationid: createdConversation.conversationid!,
            commentid: comment1.id!,
            userid: createdUser.userid!,
            reporttype: .abuse
        )
        let reportedComment1 = dummyComments[1]
        createTestComment(
            conversationid: createdConversation.conversationid!,
            userid: createdUser.userid!,
            body: "Sample Comment 2"
        )
        
        let request = CommentModerationRequest.ApproveRejectComment(
            commentid: reportedComment1.id!,
            approve: false
        )
        
        let expectation = self.expectation(description: Constants.expectation_description(#function))
        var receivedCode: Int?
        var approvedComment: Comment?
        
        commentClient.approveMessageInQueue(request) { (code, message, _, data) in
            print(message ?? "")
            receivedCode = code
            approvedComment = data
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
        XCTAssertTrue(receivedCode == 200)
        XCTAssertTrue(approvedComment != nil)
        XCTAssertTrue(approvedComment?.id == reportedComment1.id)
        XCTAssertTrue(approvedComment?.body == reportedComment1.body)
        XCTAssertTrue(approvedComment?.moderation == "rejected")
    }
    

}

///
/// Test Data
///
extension CommentClientTests {
    private func createTestUser() {
        let request = UserRequest.CreateUpdateUser(
            userid: "9940A8C9-2332-4824-B628-48390F367D29",
            handle: "GeorgeWASHING",
            displayname: "George Washing",
            pictureurl: URL(string: "http://www.thepresidentshalloffame.com/media/reviews/photos/original/a9/c7/a6/44-1-george-washington-18-1549729902.jpg"),
            profileurl: URL(string: "http://www.thepresidentshalloffame.com/1-george-washington")
        )

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        userClient.createOrUpdateUser(request) { (code, message, kind, user) in
            self.dummyUser = user
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
    }

    private func deleteTestUser() {
        guard let dummyUser else { return }

        let request = UserRequest.DeleteUser(userid: dummyUser.userid!)
        userClient.deleteUser(request) { (code, message, kind, user) in
            self.dummyUser = nil
        }
    }

    private func createTestConversation(
        conversationid: String,
        property: String,
        moderation: String,
        maxreports: Int? = nil,
        enableprofanityfilter: Bool? = nil,
        title: String? = nil,
        maxcommentlen: Int64? = nil,
        open: Bool? = nil,
        added: String? = nil,
        whenmodified: String? = nil,
        customtype: String? = nil,
        customid: String? = nil,
        customtags: [String]? = nil,
        custompayload: String? = nil,
        customfield1: String? = nil,
        customfield2: String? = nil
    ) {
        let request = CommentRequest.CreateUpdateConversation(
            conversationid: conversationid,
            property: property,
            moderation: moderation
        )
        request.maxreports = maxreports
        request.enableprofanityfilter = enableprofanityfilter
        request.title = title
        request.maxcommentlen = maxcommentlen
        request.open = open
        request.added = added
        request.whenmodified = whenmodified
        request.customtype = customtype
        request.customid = customid
        request.customtags = customtags
        request.custompayload = custompayload
        request.customfield1 = customfield1
        request.customfield2 = customfield2

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        commentClient.createOrUpdateConversation(request) { (code, message, kind, data) in
            if let data {
                self.dummyConversations.append(data)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
    }

    private func deleteTestConversations() {
        guard !dummyConversations.isEmpty else { return }
        
        var deleteConversations: [Conversation] = []
        deleteConversations.append(contentsOf: dummyConversations)
        for convo in deleteConversations {
            guard let conversationid = convo.conversationid else { continue }
            let request = CommentRequest.DeleteConversation(conversationid: conversationid)
            commentClient.deleteConversation(request) { (code, message, kind, data) in
                print("Conversation deleted: id = \(convo.conversationid)")
            }
        }
        
        dummyConversations = []
    }
    
    private func createTestComment(
        conversationid: String,
        userid: String,
        displayname: String? = nil,
        body: String,
        customtype: String? = nil,
        customfield1: String? = nil,
        customfield2: String? = nil,
        customtags: [String]? = nil,
        custompayload: String? = nil
    ) {
        let request = CommentRequest.CreateComment(
            conversationid: conversationid,
            userid: userid,
            body: body
        )

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        commentClient.createComment(request) { (code, message, kind, data) in
            if let data {
                self.dummyComments.append(data)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
    }
    
    private func createTestReplyComment(
        conversationid: String,
        replytocommentid: String,
        userid: String,
        displayname: String? = nil,
        body: String,
        customtype: String? = nil,
        customfield1: String? = nil,
        customfield2: String? = nil,
        customtags: [String]? = nil,
        custompayload: String? = nil
    ) {
        let request = CommentRequest.ReplyToComment(
            conversationid: conversationid,
            replytocommentid: replytocommentid,
            userid: userid,
            body: body
        )

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        commentClient.replyToComment(request) { (code, message, kind, data) in
            if let data {
                self.dummyComments.append(data)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
    }
    
    private func createTestReportComment(
        conversationid: String,
        commentid: String,
        userid: String,
        reporttype: ReportType
    ) {
        let request = CommentRequest.ReportComment(
            conversationid: conversationid,
            commentid: commentid,
            userid: userid,
            reporttype: reporttype
        )

        let expectation = self.expectation(description: Constants.expectation_description(#function))
        commentClient.reportComment(request) { (code, message, kind, data) in
            if let data {
                self.dummyComments.append(data)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Config.TIMEOUT, handler: nil)
    }
    
}
