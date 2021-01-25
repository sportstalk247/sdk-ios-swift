The Sportstalk SDK is a helpful wrapper around the `Sportstalk API <http://https://apiref.sportstalk247.com/?version=latest>`_

Installation
------------------
The set of SDKs and source (iOS, Android, and JS) is here: `https://gitlab.com/sportstalk247/ <https://gitlab.com/sportstalk247/>`_

.. code-block:: javascript

    pod 'SportsTalk_iOS_SDK', :git=> 'https://gitlab.com/sportstalk247/sdk-ios-swift.git'

You will need to register with SportsTalk and get an API Key in order to use SDK functions.

GETTING STARTED: Setting up the SDK
------------------
This Sportstalk SDK is meant to power custom chat applications.  Sportstalk does not enforce any restricitons on your UI design, but instead empowers your developers to focus on the user experience without worrying about the underlying chat behavior.

Sportstalk is an EVENT DRIVEN API. When new talk events occur, the SDK will trigger appropriate callbacks, if set.

.. code-block:: swift

    import SportsTalk_iOS_SDK

    // First you'll need to create a ClientConfig class that you can use later on
    let config = ClientConfig(appId: "YourAppId", authToken: "YourApiKey", endpoint: "Your URL")
    let client = UserClient(config: config)

    // You can set config to have your own endpoint or use the default endpoint like so
    let config = ClientConfig(appId: "YourAppId", authToken: "YourApiKey")


Callback Function Overview
------------------
Each and every api function has its callback, when the api is called you will get the response in the callback. You can use this to remove loading screens, hide advertisements, and so on.

Creating/Updating a user
------------------------
Invoke this API method if you want to create a user or update an existing user.

When users send messages to a room the user ID is passed as a parameter. When you retrieve the events from a room, the user who generated the event is returned with the event data, so it is easy for your application to process and render chat events with minimal code.

.. code-block:: swift

    import SportsTalk_iOS_SDK

    let client = UserClient(config: config)

    // Almost all api is designed to have a request and response model.

    func createUser() {
        // To create a request, make use of the Services convenience class
        let request = UserRequest.CreateUpdateUser()
        request.userid =  "SomeUserId"
        request.handle = "Sam"
        request.displayname = "Sam"
        request.pictureurl = URL(string: dummyUser?.pictureurl ?? "")
        request.profileurl = URL(string: dummyUser?.profileurl ?? "")

        client.createOrUpdateUser(request) { (code, message, kind, user) in
            // where; code: Int?, message: String?, kind: String?, user: User?
            // Save user
        }
    }

Joining a Room
------------------------
.. code-block:: swift

    let client = ChatClient(config: config)

    func JoinRoom(_ room: ChatRoom, as user: User) {
        let request = ChatRequest.JoinRoom()
        request.roomid = room.id
        // To join as Authenticated user, include the user to your request
        request.userid = user.userid
        request.displayname = user.displayname

        client.joinRoomAuthenticated(request) { (code, message, _, response) in
            // where response is model called JoinChatRoomResponse
            // Process response
        }
    }


Joining a Room using Custom ID
------------------
.. code-block:: swift

     let client = ChatClient(config: config)

     func JoinRoom(_ room: ChatRoom, as user: User) {
        let request = ChatRequest.JoinRoomByCustomId()
        request.userid = user.userid
        request.displayname = user.displayname
        request.customid = room.customid
    
        client.joinRoomByCustomId(request) { (code, message, _, response) in
            // where response is model called JoinChatRoomResponse
            // Process response
        }
    }


Getting room updates
------------------
To manually get room updates, use ``ChatClient().getUpdates(request:completionHandler)``

.. code-block:: swift

     let client = ChatClient(config: config)

     func getUpdates(_ room: ChatRoom) {
        let request = ChatRequest.GetUpdates()
        request.roomid = room.id

        client.getUpdates(request) { (code, message, _, response) in
            // where response is model called GetUpdatesResponse
            // Get an array of events from response.events
        }
    }


Start/Stop Getting Event Updates
------------------
Get periodic updates from room by using ``client.startListeningToChatUpdates(roomId:completionHandler)``
Only new events will be emitted, so it is up to you to collect the new events.
To stop getting updates, simply call ``client.stopListeningToChatUpdates()`` anytime.

Note:
Updates are received every 500 milliseconds.
Losing reference to client will stop the eventUpdates

.. code-block:: swift

     let client = ChatClient(config: config)
     var events = [Event]()

     func receiveUpdates(from room: ChatRoom) {
        client.startListeningToChatUpdates(from: roomid) { (code, message, _, event) in
            if let event = event {
                events.append(event)
            }
        
            // Debug pulse
            print("------------")
            print(code ==  200 ? "pulse success" : "pulse failed")
            print((event?.count ?? 0) > 0 ? "received \(event?.count) event" : "No new events")
            print("------------")
        }
    }

     func stopUpdates() {
        // Ideally call this on viewDidDisappear() and deinit()
        client.stopListeningToChatUpdates()
    }


Sending A Message
------------------
Use ``SAY`` command to send a message to the room.

example: ``SAY Hello World! or simply Hello World!``

Perform ACTIONS by using / character

example: ``/dance nicole``

* User sees: You dance with Nicole
* Nicole sees: (user) dances with you
* Everyone else sees: (user) dances with Nicole

This requires that the action command dance is on the approved list of commands and Nicole is the handle of a participant in the room, and that actions are allowed in the room

.. code-block:: swift

    let client = ChatClient(config: config)

        func send(message: String, to room: ChatRoom, as user: User) {
        // See for list of commands
        let request = ChatRequest.ExecuteChatCommand()
        request.roomId = room.id
        request.command = "SAY \(message)"
        request.userid = dummyUser?.userid

        client.executeChatCommand(request) { (code, message, _, response) in
            // where response is model called ExecuteChatCommandResponse
            // Process response
        }
    }

For use of these events in action, see the demo page: `https://www.sportstalk247.com/demo.html <https://www.sportstalk247.com/demo.html>`_

The Bare Minimum
------------------
The only critical events that you need to handle are ``ExecuteChatCommand`` which will be called for each new chat event, ``ExecuteAdminCommand`` which will handle messages from administrators, ``PurgeUserMessages`` which will be called when purge commands are issued to clear messages that violate content policy.

You will probably also want to use ``ExecuteChatCommand`` to show/hide any loading messages.

The easiest way to see how these event works is to see the demo page: `https://www.sportstalk247.com/demo.html <https://www.sportstalk247.com/demo.html>`_


Chat Application Best Practices
------------------
Do not 'fire and forget' chat messages.  Most chat applications require some level of moderation.  Your UI should make sure to keep track of message metadata such as:

    - Message ID
    - User Handle for each message.
    - User ID for each message.  In the event of moderation or purge events,  your app will need to be able to find and remove purged messages.
    - Timestamp


Use the promises from sendCommand, sendReply, etc, to show/hide some sort of indication that the message is being sent.

Make sure you handle errors for sending messages in case of network disruption. For instance, ``client.sendCommand('message').catch(handleErrorInUiFn)``

Enable/Disable debug mode with SportsTalkSDK.shared.debugMode = true/false

User Client
------------------
Create/Update User
============================
.. code-block:: javascript

    func createOrUpdateUser(_ request: UserRequest.CreateUpdateUser, completionHandler: @escaping Completion<User>)

Invoke this API method if you want to create a user or update an existing user.

When users send messages to a room the user ID is passed as a parameter. When you retrieve the events from a room, the user who generated the event is returned with the event data, so it is easy for your application to process and render chat events with minimal code.

**Arguments**

* userid: Required. If the userid is new then the user will be created. If the userid is already in use in the database then the user will be updated.
* handle: (Optional) If you are creating a user and you don't specify a handle, the system will generate one for you (using Display Name as basis if you provide that). If you request a handle and it's already in use a new handle will be generated for you and returned. Handle is an easy to type unique identifier for a user, for example @GeorgeWashington could be the handle but Display Name could be "da prez numero uno".
* displayname: Optional. This is the desired name to display, typically the real name of the person.
* pictureurl: Optional. The URL to the picture for this user.
* profileurl: Optional. The profileurl for this user.

*Warning: Do not use this method to convert an anonymous user into a known user. Use the Convert User api method instead.*

**Request Model: UserRequest.CreateUpdateUser**

.. code-block:: swift

    public class CreateUpdateUser {
        public var userid: String?
        public var handle: String?
        public var displayname: String?
        public var pictureurl: URL?
        public var profileurl: URL?
    }
        
**Response Model: User**

.. code-block:: swift

    open class User: NSObject, Codable {
        public var userid: String?
        public var handle: String?
        public var profileurl: String?
        public var banned: Bool?
        public var displayname: String?
        public var handlelowercase: String?
        public var pictureurl: String?
        public var kind: String?
    }

Delete User
============================
.. code-block:: javascript
    
    func deleteUser(_ request: UserRequest.DeleteUser, completionHandler: @escaping Completion<DeleteUserResponse>)

Deletes the specified user.

All rooms with messages by that user will have the messages from this user purged in the rooms.

**Arguments**

* userid: the app specific User ID provided by your application.

*Warning: This method requires authentication.*

**Request Model: UserRequest.DeleteUser**

.. code-block:: swift

        public class DeleteUser {
            public var userid: String?
        }
        
**Response Model: DeleteUserResponse**

.. code-block:: swift

        public struct DeleteUserResponse: Codable {
            public var kind: String?
            public var user: User?
        }


Get User Details
============================
.. code-block:: javascript
        
        func getUserDetails(_ request: UserRequest.GetUserDetails, completionHandler: @escaping Completion<User>)

Get the details about a User

This will return all the information about the user.

**Arguments**

* userid: the app specific User ID provided by your application.

*Warning: This method requires authentication.*
    
**Request Model: UserRequest.GetUserDetails**

.. code-block:: swift

        public class GetUserDetails {
            public var userid: String?
        }
        
**Response Model: User**

.. code-block:: swift

        open class User: NSObject, Codable {
            public var userid: String?
            public var handle: String?
            public var profileurl: String?
            public var banned: Bool?
            public var displayname: String?
            public var handlelowercase: String?
            public var pictureurl: String?
            public var kind: String?
        }

List Users
============================
.. code-block:: javascript

    func listUsers(_ request: UserRequest.ListUsers, completionHandler: @escaping Completion<ListUsersResponse>)

Use this method to cursor through a list of users. This method will return users in the order in which they were created, so it is safe to add new users while cursoring through the list.

**Arguments**

* cursor: Each call to ListUsers will return a result set with a 'nextCursor' value. To get the next page of users, pass this value as the optional 'cursor' property. To get the first page of users, omit the 'cursor' argument.
* limit: You can omit this optional argument, in which case the default limit is 100 users to return.

*Warning: This method requires authentication.*
    
**Request Model: UserRequest.ListUsers**

.. code-block:: swift

        public class ListUsers {
            public var cursor: String?
            public var limit: String? = defaultLimit
        }
        
**Response Model: ListUsersResponse**

.. code-block:: swift

        public struct ListUsersResponse: Codable {
            public var kind: String?
            public var cursor: String?
            public var users: [User]
        }
        
Ban/Unban User
============================
.. code-block:: javascript

    func setBanStatus(_ request: UserRequest.setBanStatus, completionHandler: @escaping Completion<User>)

Use this method ban/restore a user.

**Arguments**

* userid: (required) The applicaiton provided userid of the user to ban
* banned: (required) set true to ban a user; set false to restore a user

*Warning: This method requires authentication.*
    
**Request Model: UserRequest.setBanStatus**

.. code-block:: swift

        public class setBanStatus {
            public var userid: String?
            public var banned: Bool?
        }
        
**Response Model: User**

.. code-block:: swift

        open class User: NSObject, Codable {
            public var userid: String?
            public var handle: String?
            public var profileurl: String?
            public var banned: Bool?
            public var displayname: String?
            public var handlelowercase: String?
            public var pictureurl: String?
            public var kind: String?
        }
        
Search User
============================
.. code-block:: javascript

    func searchUser(_ request: UserRequest.SearchUser, completionHandler: @escaping Completion<ListUsersResponse>)

Searches the users in an app

Use this method to cursor through a list of users. This method will return users in the order in which they were created, so it is safe to add new users while cursoring through the list.

**Arguments**

* userid: Required. If the userid is new then the user will be created. If the userid is already in use in the database then the user will be updated.
* cursor: Each call to ListUsers will return a result set with a 'nextCursor' value. To get the next page of users, pass this value as the optional 'cursor' property. To get the first page of users, omit the 'cursor' argument.
* limit: You can omit this optional argument, in which case the default limit is 200 users to return.
* name: Provide part of a name to search the user name field
* handle: Provide part of a handle to search by handle
* userid: Provide part of a userid to search by userid

*Warning: This method requires authentication.*
    
**Request Model: UserRequest.SearchUser**

.. code-block:: swift

        public class SearchUser {
            public var cursor:String?
            public var limit:Int?
            public var name:String?
            public var handle:String?
            public var userid:String?
        }
        
**Response Model: ListUsersResponse**

.. code-block:: swift

        public struct ListUsersResponse: Codable {
            public var kind: String?
            public var cursor: String?
            public var users: [User]
        }

Chat Client
------------------

Create Room
============================
.. code-block:: javascript
    
    func createRoom(_ request: ChatRequest.CreateRoom, completionHandler: @escaping Completion<ChatRoom>)

Creates a new chat room

**Arguments**

* name: (required) The name of the room
* customid: (optional) A customid for the room. Can be unused, or a unique key.
* description: (optional) The description of the room
* moderation: (required) The type of moderation.

    * pre - marks the room as Premoderated
    * post - marks the room as Postmoderated
    
* enableactions: (optional) [true/false] Turns action commands on or off
* enableenterandexit: (optional) [true/false] Turn enter and exit events on or off. Disable for large rooms to reduce noise.
* enableprofanityfilter: (optional) [default=true / false] Enables profanity filtering.
* delaymessageseconds: (optional) [default=0] Puts a delay on messages from when they are submitted until they show up in the chat. Used for throttling.
* maxreports: (optiona) Default is 3. This is the maximum amount of user reported flags that can be applied to a message before it is sent to the moderation queue

*Warning: This method requires authentication.*
    
**Request Model: ChatRequest.CreateRoom**

.. code-block:: swift

        public class CreateRoom {
            public var name: String?
            public var customid: String?
            public var description: String?
            public var moderation: String?
            public var enableactions: Bool?
            public var enableenterandexit: Bool?
            public var enableprofanityfilter: Bool?
            public var roomisopen: Bool?
            public var maxreports: Int? = 3
        }
        
**Response Model: ChatRoom**

.. code-block:: swift

        open class ChatRoom: Codable {
            public var kind: String?
            public var id: String?
            public var appid: String?
            public var ownerid: String?
            public var name: String?
            public var description: String?
            public var customtype: String?
            public var customid: String?
            public var custompayload: String?
            public var customtags: [String]?
            public var customfield1: String?
            public var customfield2: String?
            public var enableactions: Bool?
            public var enableenterandexit: Bool?
            public var open: Bool?
            public var inroom: Int?
            public var moderation: String?
            public var maxreports: Int64?
            public var enableprofanityfilter: Bool?
            public var delaymessageseconds: Int64?
            public var added: Date?
            public var whenmodified: Date?
        }
        
Get Room Details
============================
.. code-block:: javascript

    func getRoomDetails(_ request: ChatRequest.GetRoomDetails, completionHandler: @escaping Completion<ChatRoom>)

Get the details for a room

**Arguments**

* roomid: Room Id of a specific room againts which you want to fetch the details

*Warning: This method requires authentication.*

**Request Model: ChatRequest.GetRoomDetails**

.. code-block:: swift

        public class GetRoomDetails {
            public var roomid: String?
        }
                
**Response Model: ChatRoom**

.. code-block:: swift

        open class ChatRoom: Codable {
            public var kind: String?
            public var id: String?
            public var appid: String?
            public var ownerid: String?
            public var name: String?
            public var description: String?
            public var customtype: String?
            public var customid: String?
            public var custompayload: String?
            public var customtags: [String]?
            public var customfield1: String?
            public var customfield2: String?
            public var enableactions: Bool?
            public var enableenterandexit: Bool?
            public var open: Bool?
            public var inroom: Int?
            public var moderation: String?
            public var maxreports: Int64?
            public var enableprofanityfilter: Bool?
            public var delaymessageseconds: Int64?
            public var added: Date?
            public var whenmodified: Date?
        }
        
Delete Room
============================
.. code-block:: javascript

    func deleteRoom(_ request: ChatRequest.DeleteRoom, completionHandler: @escaping Completion<DeleteChatRoomResponse>)

Deletes the specified room and all events contained therein) by ID

**Arguments**

* roomid: the id of the room you want to delete

*Warning: This method requires authentication.*

**Request Model: ChatRequest.DeleteRoom**

.. code-block:: swift

        public class DeleteRoom {
            public var roomid: String?
        }
                
**Response Model: DeleteChatRoomResponse**

.. code-block:: swift

        public struct DeleteChatRoomResponse: Codable {
            public var kind: String?
            public var deletedEventsCount: Int64?
            public var room: ChatRoom?
        }

Update Room
============================
.. code-block:: javascript

    func updateRoom(_ request: ChatRequest.UpdateRoom, completionHandler: @escaping Completion<ChatRoom>)

Updates an existing room

**Arguments**

* roomid: (required) The ID of the existing room
* name: (optional) The name of the room
* description: (optional) The description of the room
* moderation: (optional) [premoderation/postmoderation] Defaults to post-moderation.
* enableactions: (optional) [true/false] Turns action commands on or off
* enableenterandexit: (optional) [true/false] Turn enter and exit events on or off. Disable for large rooms to reduce noise.
* enableprofanityfilter: (optional) [default=true / false] Enables profanity filtering.
* delaymessageseconds: (optional) [default=0] Puts a delay on messages from when they are submitted until they show up in the chat. Used for throttling.
* roomisopen: (optional) [true/false] If false, users cannot perform any commands in the room, chat is suspended.
* throttle: (optional) Defaults to 0. This is the number of seconds to delay new incomming messags so that the chat room doesn't scroll messages too fast.
* userid:  user id specific to App

*Warning: This method requires authentication.*

**Request Model: ChatRequest.UpdateRoom**

.. code-block:: swift

        public class UpdateRoom {
            public var roomid: String?
            public var name: String?
            public var description: String?
            public var customid: String?
            public var moderation: String?
            public var enableactions: Bool?
            public var enableenterandexit: Bool?
            public var enableprofanityfilter: Bool?
            public var delaymessageseconds: Int?
            public var roomisopen:Bool?
            public var throttle:Int?
            public var userid:String?
        }
                
**Response Model: ChatRoom**

.. code-block:: swift

        open class ChatRoom: Codable {
            public var kind: String?
            public var id: String?
            public var appid: String?
            public var ownerid: String?
            public var name: String?
            public var description: String?
            public var customtype: String?
            public var customid: String?
            public var custompayload: String?
            public var customtags: [String]?
            public var customfield1: String?
            public var customfield2: String?
            public var enableactions: Bool?
            public var enableenterandexit: Bool?
            public var open: Bool?
            public var inroom: Int?
            public var moderation: String?
            public var maxreports: Int64?
            public var enableprofanityfilter: Bool?
            public var delaymessageseconds: Int64?
            public var added: Date?
            public var whenmodified: Date?
        }
        
Update and Close Room
============================
.. code-block:: javascript

    func updateCloseRoom(_ request: ChatRequest.UpdateRoomCloseARoom, completionHandler: @escaping Completion<ChatRoom>)

Update Room (Close a room)

**Arguments**

* roomid: (required) The ID of the existing room
* name: (optional) The name of the room
* description: (optional) The description of the room
* moderation: (optional) [premoderation/postmoderation] Defaults to post-moderation.
* enableactions: (optional) [true/false] Turns action commands on or off
* enableenterandexit: (optional) [true/false] Turn enter and exit events on or off. Disable for large rooms to reduce noise.
* enableprofanityfilter: (optional) [default=true / false] Enables profanity filtering.
* delaymessageseconds: (optional) [default=0] Puts a delay on messages from when they are submitted until they show up in the chat. Used for throttling.
* room, chat is suspended.
* userid:  user id specific to App

*Warning: This method requires authentication.*

**Request Model: ChatRequest.UpdateRoomCloseARoom**

.. code-block:: swift

    public class UpdateRoomCloseARoom {
        public var roomid: String?
        public var name: String?
        public var description: String?
        public var moderation: String?
        public var enableactions: Bool?
        public var enableenterandexit: Bool?
        public var enableprofanityfilter: Bool?
        public var delaymessageseconds: Int?
        public var roomisopen:Bool? = false
        public var userid:String?
    }
                
Response Model: ChatRoom

.. code-block:: swift

        open class ChatRoom: Codable {
            public var kind: String?
            public var id: String?
            public var appid: String?
            public var ownerid: String?
            public var name: String?
            public var description: String?
            public var customtype: String?
            public var customid: String?
            public var custompayload: String?
            public var customtags: [String]?
            public var customfield1: String?
            public var customfield2: String?
            public var enableactions: Bool?
            public var enableenterandexit: Bool?
            public var open: Bool?
            public var inroom: Int?
            public var moderation: String?
            public var maxreports: Int64?
            public var enableprofanityfilter: Bool?
            public var delaymessageseconds: Int64?
            public var added: Date?
            public var whenmodified: Date?
        }
        
List Rooms
============================
.. code-block:: javascript

    func listRooms(_ request: ChatRequest.ListRooms, completionHandler: @escaping Completion<ListRoomsResponse>)

List all the available public chat rooms

Rooms can be public or private. This method lists all public rooms that everyone can see.

*Warning: This method requires authentication.*

**Request Model: ChatRequest.ListRooms**

.. code-block:: swift

    public class ListRooms {
        public init() { }
        // Nothing to configure
    }
                
Response Model: ListRoomsResponse

.. code-block:: swift

        public struct ListRoomsResponse: Codable {
            public var kind: String?
            public var cursor: String?
            public var more: Bool?
            public var itemcount: Int64?
            public var rooms: [ChatRoom]
        }
        
List Room Participants
============================
.. code-block:: javascript

    func listRooms(_ request: ChatRequest.ListRooms, completionHandler: @escaping Completion<ListRoomsResponse>)

List all the participants in the specified room

Use this method to cursor through the people who have subscribe to the room.

To cursor through the results if there are many participants, invoke this function many times. Each result will return a cursor value and you can pass that value to the next invokation to get the next page of results. The result set will also include a next field with the full URL to get the next page, so you can just keep reading that and requesting that URL until you reach the end. When you reach the end, no more results will be returned or the result set will be less than maxresults and the next field will be empty.

**Arguments**

* roomid:  room id that you want to list the participants
* cursor:  you can pass that value to the next invokation to get the next page of results
* limit: default is 200

*Warning: This method requires authentication.*

**Request Model: ChatRequest.ListRoomParticipants**

.. code-block:: swift

        public class ListRoomParticipants {
            public var roomid: String?
            public var cursor: String? = ""
            public var limit: Int? = 200
        }
                
**Response Model: ListChatRoomParticipantsResponse**

.. code-block:: swift

        public struct ListChatRoomParticipantsResponse: Codable {
            public var kind: String?
            public var cursor: String?
            public var participants: [ChatRoomParticipant]
        }

Join Room
============================
.. code-block:: javascript

    func joinRoom(_ request: ChatRequest.JoinRoom, completionHandler: @escaping Completion<JoinChatRoomResponse>)

You can join a room either by using the room ID or label. First this method attempts to join a room with the specified ID. If the ID is not found, it attempts to join using the specified label. Labels must be URL friendly. The label is provided when the room is created. For example, if you wanted to label the room with the ID of a match, you can join the room without the need to invoke list rooms to get a room id.

Logged in users:
    * To log a user in, provide a unique user ID string and chat handle string. If this is the first time the user ID has been used a new user record will be created for the user. Whenever the user creates an event in the room by doing an action like saying something, the user information will be returned.
    * You can optionally also provide a URL to an image and a URL to a profile.
    * If you provide user information and the user already exists in the database, the user will be updated with the new information.
    * The user will be added to the list of participants in the room and the room participant count will increase.
    * The user will be removed from the room automatically after some time if the user doesn't perform any operations.
    * Users can only execute commands in the room if they have joined the room.
    * When a logged in user joins a room an entrance event is generated in the room.
    * When a logged in user leaves a room, an exit event is generated in the room.

**Arguments**

* roomid: (required) The room you want to join
* userid: user id specific to App
* handle: user handle specific to App
* displayname: Display Name for user
* pictureurl:  Picture url of user
* profileurl: Profile url of user

*Warning: This method requires authentication.*

**Request Model: ChatRequest.JoinRoom**

.. code-block:: swift

        public class JoinRoom {
            public var roomid: String?
            public var userid: String?
            public var handle: String?
            public var displayname: String?
            public var pictureurl: URL?
            public var profileurl: URL?
        }
                
**Response Model: JoinChatRoomResponse**

.. code-block:: swift

        public struct JoinChatRoomResponse: Codable {
            public var kind: String?
            public var user: User?
            public var room: ChatRoom?
            public var eventscursor: GetUpdatesResponse?
        }
        
Join Room by CustomId
============================
.. code-block:: javascript

    func joinRoomByCustomId(_ request: ChatRequest.JoinRoomByCustomId, completionHandler: @escaping Completion<JoinChatRoomResponse>)

This method is the same as Join Room, except you can use your customid

The benefit of this method is you don't need to query to get the roomid using customid, and then make another call to join the room. This eliminates a request and enables you to bring your chat experience to your user faster.

Logged in users:
    * To log a user in, provide a unique user ID string and chat handle string. If this is the first time the user ID has been used a new user record will be created for the user. Whenever the user creates an event in the room by doing an action like saying something, the user information will be returned.
    * You can optionally also provide a URL to an image and a URL to a profile.
    * If you provide user information and the user already exists in the database, the user will be updated with the new information.
    * The user will be added to the list of participants in the room and the room participant count will increase.
    * The user will be removed from the room automatically after some time if the user doesn't perform any operations.
    * Users can only execute commands in the room if they have joined the room.
    * When a logged in user joins a room an entrance event is generated in the room.
    * When a logged in user leaves a room, an exit event is generated in the room.

**Arguments**

* customid: your custom id
* userid: user id specific to App
* handle: user handle specific to App
* displayname: Display Name for user
* pictureurl:  Picture url of user
* profileurl: Profile url of user

*Warning: This method requires authentication.*

**Request Model: ChatRequest.JoinRoomByCustomId**

.. code-block:: swift

        public class JoinRoomByCustomId {
            public var customid: String?
            public var userid: String?
            public var handle: String?
            public var displayname: String?
            public var pictureurl: URL?
            public var profileurl: URL?
        }
                
**Response Model: JoinChatRoomResponse**

.. code-block:: swift
        
        public struct JoinChatRoomResponse: Codable {
            public var kind: String?
            public var user: User?
            public var room: ChatRoom?
            public var eventscursor: GetUpdatesResponse?
        }
        
Exit Room
============================
.. code-block:: javascript

    func exitRoom(_ request: ChatRequest.ExitRoom, completionHandler: @escaping Completion<ExitChatRoomResponse>)

**Arguments**

* roomid:  Room id that you want to exit
* userid:  user id specific to App

*Warning: This method requires authentication.*

**Request Model: ChatRequest.ExitRoom**

.. code-block:: swift

        public class ExitRoom {
            public var roomid: String?
            public var userid: String?
        }
                
**Response Model: ExitChatRoomResponse**

.. code-block:: swift

        public struct ExitChatRoomResponse: Codable {
            public var kind: String?
        }

Get Updates
============================
.. code-block:: javascript

    func getUpdates(_ request: ChatRequest.GetUpdates, completionHandler: @escaping Completion<GetUpdatesResponse>)

Get the Recent Updates to a Room

You can use this function to poll the room to get the recent events in the room. The recommended poll interval is 500ms. Each event has an ID and a timestamp. To detect new messages using polling, call this function and then process items with a newer timestamp than the most recent one you have already processed.

Each event in the stream has a KIND property. Inspect the property to determine if it is a... enter event: A user has joined the room.

exit event: A user has exited chat. message: A user has communicated a message. reply: A user sent a message in response to another user. reaction: A user has reacted to a message posted by another user. action: A user is performing an ACTION (emote) alone or with another user.

ENTER AND EXIT EVENTS:

Enter and Exit events may not be sent if the room is expected to have a very large number of users.

**Arguments**

* roomid:  Room id that you want to update
* cursor:  Used in cursoring through the list. Gets the next batch of users. Read 'nextCur' property of result set and pass as cursor value.

*Warning: This method requires authentication.*

**Request Model: ChatRequest.GetUpdates**

.. code-block:: swift

        public class GetUpdates {
            public var roomid: String?
            public var cursor: String?
        }
                
**Response Model: GetUpdatesResponse**

.. code-block:: swift

        public struct GetUpdatesResponse: Codable {
            public var kind: String?
            public var cursor: String?
            public var more: Bool?
            public var itemcount: Int64?
            public var room: ChatRoom?
            public var events: [Event]
        }
        
Execute Command
============================
.. code-block:: javascript

    func executeChatCommand(_ request: ChatRequest.ExecuteChatCommand, completionHandler: @escaping Completion<ExecuteChatCommandResponse>)

Executes a command in a chat room

SENDING A MESSAGE:

* Send any text that doesn't start with a reserved symbol to perform a SAY command.
* Use this API call to REPLY to existing messages
* Use this API call to perform ACTION commands
* Use this API call to perform ADMIN commands

example:
These commands both do the same thing, which is send the message "Hello World" to the room. SAY Hello, World Hello, World

ACTION COMMANDS:

* Action commands start with the / character

example:
``/dance nicole``

User sees:
* You dance with Nicole
* Nicole sees: (user's handle) dances with you
* Everyone else sees: (user's handle) dances with Nicole

 This requires that the action command dance is on the approved list of commands and Nicole is the handle of a participant in the room, and that actions are allowed in the room.

ADMIN COMMANDS:

* These commands start with the * character
Each event in the stream has a KIND property. Inspect the property to determine if it is a... enter event: A user has joined the room.

example:

* ban : This bans the user from the entire chat experience (all rooms).
* restore : This restores the user to the chat experience (all rooms).
* purge : This deletes all messages from the specified user.
* deleteallevents : This deletes all messages in this room.

SENDING A REPLY:

* replyto:  Use this field to provide the EventID of an event you want to reply to. Replies have a different event type and contain a copy of the original event.

**Arguments**

* command:  command that you want to pass
* userid: user id specific to App
* customtype: any type you want to save
* customid: any custom id you want to pass
* custompayload: any payload.

*Warning: This method requires authentication.*

**Request Model: ChatRequest.ExecuteChatCommand**

.. code-block:: swift

        public class ExecuteChatCommand {
            public var roomid: String?
            public var command: String?
            public var userid: String?
            public var moderation: String?
            public var eventtype: EventType?
            public var customtype: String?
            public var customid: String?
            public var custompayload: String?
        }
                
**Response Model: ExecuteChatCommandResponse**

.. code-block:: swift

        public struct ExecuteChatCommandResponse: Codable {
            public var kind: String?
            public var op: String?
            public var room: ChatRoom?
            public var speech: Event?
            public var action: Event?
        }

Send Quoted Reply
============================
.. code-block:: javascript

func sendQuotedReply(_ request: ChatRequest.SendQuotedReply, completionHandler: @escaping Completion<ExecuteChatCommandResponse>)

Executes a command in a chat room

SENDING A MESSAGE:

* Send any text that doesn't start with a reserved symbol to perform a SAY command.
* Use this API call to REPLY to existing messages
* Use this API call to perform ACTION commands
* Use this API call to perform ADMIN commands

example:
These commands both do the same thing, which is send the message "Hello World" to the room. SAY Hello, World Hello, World

ACTION COMMANDS:

* Action commands start with the / character

example:
``/dance nicole``

User sees:
* You dance with Nicole
* Nicole sees: (user's handle) dances with you
* Everyone else sees: (user's handle) dances with Nicole

 This requires that the action command dance is on the approved list of commands and Nicole is the handle of a participant in the room, and that actions are allowed in the room.

ADMIN COMMANDS:

* These commands start with the * character
Each event in the stream has a KIND property. Inspect the property to determine if it is a... enter event: A user has joined the room.

example:

* ban : This bans the user from the entire chat experience (all rooms).
* restore : This restores the user to the chat experience (all rooms).
* purge : This deletes all messages from the specified user.
* deleteallevents : This deletes all messages in this room.

SENDING A REPLY:

* replyto:  Use this field to provide the EventID of an event you want to reply to. Replies have a different event type and contain a copy of the original event.

**Arguments**

* command:  command that you want to pass
* userid: user id specific to App
* customtype: any type you want to save
* customid: any custom id you want to pass
* custompayload: any payload.

*Warning: This method requires authentication.*

**Request Model: ChatRequest.SendQuotedReply**

.. code-block:: swift

        public class SendQuotedReply {
            public var roomid: String?
            public var command: String?
            public var userid: String?
            public var replyto: String?
        }
                
**Response Model: ExecuteChatCommandResponse**

.. code-block:: swift

        public struct ExecuteChatCommandResponse: Codable {
            public var kind: String?
            public var op: String?
            public var room: ChatRoom?
            public var speech: Event?
            public var action: Event?
        }
        
Send Threaded Reply
============================
.. code-block:: javascript
        
        func sendQuotedReply(_ request: ChatRequest.SendQuotedReply, completionHandler: @escaping Completion<ExecuteChatCommandResponse>)

Executes a command in a chat room

SENDING A MESSAGE:

* Send any text that doesn't start with a reserved symbol to perform a SAY command.
* Use this API call to REPLY to existing messages
* Use this API call to perform ACTION commands
* Use this API call to perform ADMIN commands

example:
These commands both do the same thing, which is send the message "Hello World" to the room. SAY Hello, World Hello, World

ACTION COMMANDS:

* Action commands start with the / character

example:
``/dance nicole``

User sees:
* You dance with Nicole
* Nicole sees: (user's handle) dances with you
* Everyone else sees: (user's handle) dances with Nicole

 This requires that the action command dance is on the approved list of commands and Nicole is the handle of a participant in the room, and that actions are allowed in the room.

ADMIN COMMANDS:

* These commands start with the * character
Each event in the stream has a KIND property. Inspect the property to determine if it is a... enter event: A user has joined the room.

example:

* ban : This bans the user from the entire chat experience (all rooms).
* restore : This restores the user to the chat experience (all rooms).
* purge : This deletes all messages from the specified user.
* deleteallevents : This deletes all messages in this room.

SENDING A REPLY:

* replyto:  Use this field to provide the EventID of an event you want to reply to. Replies have a different event type and contain a copy of the original event.

**Arguments**

* command:  command that you want to pass
* userid: user id specific to App
* customtype: any type you want to save
* customid: any custom id you want to pass
* custompayload: any payload.

*Warning: This method requires authentication.*

**Request Model: ChatRequest.SendThreadedReply**

.. code-block:: swift

        public class SendThreadedReply {
            public var roomid: String?
            public var command: String?
            public var userid: String?
            public var replyto: String?
        }
                
**Response Model: ExecuteChatCommandResponse**

.. code-block:: swift

        public struct ExecuteChatCommandResponse: Codable {
            public var kind: String?
            public var op: String?
            public var room: ChatRoom?
            public var speech: Event?
            public var action: Event?
        }

Purge Message
============================
.. code-block:: javascript

    func purgeMessage(_ request: ChatRequest.PurgeUserMessages, completionHandler: @escaping Completion<ExecuteChatCommandResponse>)

Executes a command in a chat room to purge all messages for a user

This does not DELETE the message. It flags the message as moderator removed.

**Arguments**

* handle: the handle of the owner of the messages
* password: a valid admin password

*Warning: This method requires authentication.*

**Request Model: ChatRequest.PurgeUserMessages**

.. code-block:: swift

        public class PurgeUserMessages {
            public var handle: String!
            public var password: String!
        }
                
**Response Model: ExecuteChatCommandResponse**

.. code-block:: swift

        public struct ExecuteChatCommandResponse: Codable {
            public var kind: String?
            public var op: String?
            public var room: ChatRoom?
            public var speech: Event?
            public var action: Event?
        }

Delete Event
============================
.. code-block:: javascript
    
    func deleteEvent(_ request: ChatRequest.DeleteEvent, completionHandler: @escaping Completion<DeleteEventResponse>)

Removes a message from a room.

This does not DELETE the message. It flags the message as moderator removed.

**Arguments**

* roomid:  the room id in which you want to remove the message
* eventid:  the message you want to remove
* userid: (Optional)  the id to whom the message belongs to. If provided, a check will be made to enforce this userid (the one deleting the event) is the owner of the event or has elevated permissions. If null, it assumes your business service made the determination to delete the event.
* permanent: (Optional) remove permanently if no reply. Defaults to true

*Warning: This method requires authentication.*

**Request Model: ChatRequest.DeleteEvent**

.. code-block:: swift

        public class DeleteEvent {
            public var roomid: String!
            public var eventid: String!
            public var userid: String?
            public var permanent: Bool? = true
        }
                
**Response Model: DeleteEventResponse**

.. code-block:: swift

        public struct DeleteEventResponse: Codable {
            public var kind: String?
            public var permanentdelete: Bool?
            public var event: Event?
        }
        
Delete All Events
============================
.. code-block:: javascript

    func deleteAllEvents(_ request: ChatRequest.DeleteAllEvents, completionHandler: @escaping Completion<ExecuteChatCommandResponse>)

Removes all messages in a room.

**Arguments**

* password: a valid admin password

*Warning: This method requires authentication.*

**Request Model: ChatRequest.DeleteAllEvents**

.. code-block:: swift

        public class DeleteAllEvents {
            public var password: String!
            public var userid: String!
        }
                
**Response Model: ExecuteChatCommandResponse**

.. code-block:: swift

        public struct ExecuteChatCommandResponse: Codable {
            public var kind: String?
            public var op: String?
            public var room: ChatRoom?
            public var speech: Event?
            public var action: Event?
        }
        
List Messages of User
============================
.. code-block:: javascript

    func listMessagesByUser(_ request: ChatRequest.ListMessagesByUser, completionHandler: @escaping Completion<ListMessagesByUserResponse>)

Gets a list of users messages

The purpose of this method is to get a list of messages or comments by a user, with count of replies and reaction data. This way, you can easily make a screen in your application that shows the user a list of their comment contributions and how people reacted to it.

**Arguments**

* roomid:  Room id, in which you want to fetch messages
* userid:  user id, against which you want to fetch messages
* cursor:  Used in cursoring through the list. Gets the next batch of users. Read 'nextCur' property of result set and pass as cursor value.
* limit: default 100

*Warning: This method requires authentication.*

**Request Model: ChatRequest.ListMessagesByUser**

.. code-block:: swift

        public class ListMessagesByUser {
            public var cursor: String?
            public var limit: String? = defaultLimit
            public var userId: String?
            public var roomid: String?
        }
                
**Response Model: ListMessagesByUserResponse**

.. code-block:: swift

        public struct ListMessagesByUserResponse: Codable {
            public var kind: String?
            public var cursor: String?
            public var events: [Event]
        }
        
Report A Message
============================
.. code-block:: javascript

    func reportMessage(_ request: ChatRequest.ReportMessage, completionHandler: @escaping Completion<Event>)

REPORTS a message to the moderation team

A reported message is temporarily removed from the chat event stream until it is evaluated by a moderator.

**Arguments**

* reporttype:  e.g. abuse
* userid:  user id specific to app
* chatRoomId: Room Id, in which you want to report the message
* chatMessageId: message id, that you want to report.

*Warning: This method requires authentication.*

**Request Model: ChatRequest.ReportMessage**

.. code-block:: swift

        public class ReportMessage {
            public var chatRoomId: String?
            public var chatMessageId: String?
            public var chat_room_newest_speech_id: String?
            public var userid: String?
            public var reporttype = "abuse"
        }
                
**Response Model: Event**

.. code-block:: swift

        open class Event: Codable, Equatable {
            public var kind: String?
            public var id: String?
            public var roomid: String?
            public var body: String?
            public var originalbody: String?
            public var added: Date?
            public var modified: Date?
            public var ts: Date?
            public var eventtype: EventType?
            public var userid: String?
            public var user: User?
            public var customtype: String?
            public var customid: String?
            public var custompayload: String?
            public var customtags: [String]?
            public var customfield1: String?
            public var customfield2: String?
            public var replyto: Event?
            public var parentid: String?
            public var edited: Bool?
            public var editedbymoderator: Bool?
            public var censored: Bool?
            public var deleted: Bool?
            public var active: Bool?
            public var shadowban: Bool?
            public var likecount: Int64?
            public var replycount: Int64?
            public var reactions: [ChatEventReaction]
            public var moderation: String?
            public var reports: [ChatEventReport]
        }
        
React to an Event
============================
.. code-block:: javascript

    func reactToEvent(_ request: ChatRequest.ReactToEvent, completionHandler: @escaping Completion<Event>)

Adds or removes a reaction to an existing event

After this completes, a new event appears in the stream representing the reaction. The new event will have an updated version of the event in the replyto field, which you can use to update your UI.

**Arguments**

* userid:  user id specific to app
* roomId: Room Id, in which you want to react
* roomNewestEventId: message id, that you want to report.
* reacted: true/false
* reaction: e.g. like

*Warning: This method requires authentication.*
    
**Request Model: ChatRequest.ReactToEvent**

.. code-block:: swift

        public class ReactToEvent {
            public var roomid: String?
            public var eventid: String?
            public var userid: String?
            public var reaction: String?
            public var reacted: String? = "true"
        }
                
**Response Model: Event**

.. code-block:: swift

        open class Event: Codable, Equatable {
            public var kind: String?
            public var id: String?
            public var roomid: String?
            public var body: String?
            public var originalbody: String?
            public var added: Date?
            public var modified: Date?
            public var ts: Date?
            public var eventtype: EventType?
            public var userid: String?
            public var user: User?
            public var customtype: String?
            public var customid: String?
            public var custompayload: String?
            public var customtags: [String]?
            public var customfield1: String?
            public var customfield2: String?
            public var replyto: Event?
            public var parentid: String?
            public var edited: Bool?
            public var editedbymoderator: Bool?
            public var censored: Bool?
            public var deleted: Bool?
            public var active: Bool?
            public var shadowban: Bool?
            public var likecount: Int64?
            public var replycount: Int64?
            public var reactions: [ChatEventReaction]
            public var moderation: String?
            public var reports: [ChatEventReport]
        }

Start Listening to Chat Updates
============================
.. code-block:: javascript

    func startListeningToChatUpdates(completionHandler: @escaping Completion<[Event]>)

Periodically calls func getUpdates(request:completionHandler:) to receive latest chat events.

**Request Model: None**
                
**Response Model: GetUpdatesResponse**

.. code-block:: swift

        public struct GetUpdatesResponse: Codable {
            public var kind: String?
            public var cursor: String?
            public var more: Bool?
            public var itemcount: Int64?
            public var room: ChatRoom?
            public var events: [Event]
        }

Stop Listening to Chat Updates
============================
.. code-block:: javascript

    func stopListeningToChatUpdates()

Cancels listening to Chat Updates

**Request Model: None**
                
**Response Model: None**

Approve Event
============================
.. code-block:: javascript
    
    func approveEvent(_ request: ModerationRequest.ApproveEvent, completionHandler: @escaping Completion<Event>)

APPROVES a message in the moderation queue

If PRE-MODERATION is enabled for a room, then all messages go to the queue before they can appear in the event stream. For each incomming message, a webhook will be fired, if one is configured.

If the room is set to use POST-MODERATION, messages will only be sent to the moderation queue if they are reported.

*Warning: Requires Authentication*

**Request Model: ModerationRequest.ApproveEvent**

.. code-block:: swift

        public class ApproveEvent {
            public var chatRoomId: String?
            public var chatMessageId: String?
        }
                
**Response Model: Event**

.. code-block:: swift

        open class Event: Codable, Equatable {
            public var kind: String?
            public var id: String?
            public var roomid: String?
            public var body: String?
            public var originalbody: String?
            public var added: Date?
            public var modified: Date?
            public var ts: Date?
            public var eventtype: EventType?
            public var userid: String?
            public var user: User?
            public var customtype: String?
            public var customid: String?
            public var custompayload: String?
            public var customtags: [String]?
            public var customfield1: String?
            public var customfield2: String?
            public var replyto: Event?
            public var parentid: String?
            public var edited: Bool?
            public var editedbymoderator: Bool?
            public var censored: Bool?
            public var deleted: Bool?
            public var active: Bool?
            public var shadowban: Bool?
            public var likecount: Int64?
            public var replycount: Int64?
            public var reactions: [ChatEventReaction]
            public var moderation: String?
            public var reports: [ChatEventReport]
        }
        
Reject Event
============================
.. code-block:: javascript

    func rejectEvent(_ request: ModerationRequest.RejectEvent, completionHandler: @escaping Completion<Event>)

REJECTS a message in the moderation queue

If PRE-MODERATION is enabled for a room, then all messages go to the queue before they can appear in the event stream. For each incomming message, a webhook will be fired, if one is configured.

If the room is set to use POST-MODERATION, messages will only be sent to the moderation queue if they are reported.

*Warning: Requires Authentication*

**Request Model: ModerationRequest.RejectEvent**

.. code-block:: swift

        public class RejectEvent {
            public var chatRoomId: String?
            public var chatMessageId: String?
        }
                
**Response Model: Event**

.. code-block:: swift

        open class Event: Codable, Equatable {
            public var kind: String?
            public var id: String?
            public var roomid: String?
            public var body: String?
            public var originalbody: String?
            public var added: Date?
            public var modified: Date?
            public var ts: Date?
            public var eventtype: EventType?
            public var userid: String?
            public var user: User?
            public var customtype: String?
            public var customid: String?
            public var custompayload: String?
            public var customtags: [String]?
            public var customfield1: String?
            public var customfield2: String?
            public var replyto: Event?
            public var parentid: String?
            public var edited: Bool?
            public var editedbymoderator: Bool?
            public var censored: Bool?
            public var deleted: Bool?
            public var active: Bool?
            public var shadowban: Bool?
            public var likecount: Int64?
            public var replycount: Int64?
            public var reactions: [ChatEventReaction]
            public var moderation: String?
            public var reports: [ChatEventReport]
        }
        
List All Messages In Moderation Queue
============================
.. code-block:: javascript

    func listMessagesInModerationQueue(_ request: ModerationRequest.listMessagesInModerationQueue, completionHandler: @escaping Completion<ListMessagesNeedingModerationResponse>)

**Arguments**

* limit: (optional) Defaults to 200. This limits how many messages to return from the queue
* roomId: (optional) Provide the ID for a room to filter for only the queued events for a specific room
* cursor: (optional) Provide cursor value to get the next page of results.

*Warning: Requires Authentication*

**Request Model: ModerationRequest.listMessagesInModerationQueue**

.. code-block:: swift

        public class listMessagesInModerationQueue {
            public var chatRoomId: String?
            public var chatMessageId: String?
        }
                
**Response Model: ListMessagesNeedingModerationResponse**

.. code-block:: swift

        public var kind: String?
        public var events: [Event]


Copyright & License
-------------------
Copyright (c) 2019 Sportstalk247




.. toctree::
   :maxdepth: 2
   :caption: Contents:

Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
