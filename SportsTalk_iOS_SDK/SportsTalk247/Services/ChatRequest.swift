import Foundation

public class ChatRequest {
    /// Creates a new chat room (Postmoderated)
    ///
    /// name: (required) The name of the room
    ///
    /// customid: (optional) A customid for the room. Can be unused, or a unique key.
    ///
    /// description: (optional) The description of the room
    ///
    /// moderation: (required) The type of moderation.
    ///  - ```pre``` - marks the room as Premoderated
    ///  - ```post``` - marks the room as Postmoderated
    ///
    /// enableactions: (optional) [true/false] Turns action commands on or off
    ///
    /// enableenterandexit: (optional) [true/false] Turn enter and exit events on or off. Disable for large rooms to reduce noise.
    ///
    /// enableprofanityfilter: (optional) [default=true / false] Enables profanity filtering.
    ///
    /// delaymessageseconds: (optional) [default=0] Puts a delay on messages from when they are submitted until they show up in the chat. Used for throttling.
    ///
    /// maxreportss: (optiona) Default is 3. This is the maximum amount of user reported flags that can be applied to a message before it is sent to the moderation queue
    ///
    /// - Warning: This method requires authentication.
    public class CreateRoom: ParametersBase<CreateRoom.Fields, CreateRoom> {
        public enum Fields {
            case name
            case customid
            case description
            case moderation
            case enableactions
            case enableenterandexit
            case enableprofanityfilter
            case roomisopen
            case maxreports
        }
        
        public var name: String?
        public var customid: String?
        public var description: String?
        public var moderation: String?
        public var enableactions: Bool?
        public var enableenterandexit: Bool?
        public var enableprofanityfilter: Bool?
        public var roomisopen: Bool?
        public var maxreports: Int? = 3
        
        
        override public func from(dictionary: [AnyHashable: Any]) -> CreateRoom {
            set(dictionary: dictionary)
            let ret = CreateRoom()
        
            ret.name = value(forKey: .name)
            ret.customid = value(forKey: .customid)
            ret.description = value(forKey: .description)
            ret.enableactions = value(forKey: .enableactions)
            ret.enableenterandexit = value(forKey: .enableenterandexit)
            ret.enableprofanityfilter = value(forKey: .enableprofanityfilter)
            ret.roomisopen = value(forKey: .roomisopen)
            ret.maxreports = value(forKey: .maxreports)
            
            return ret
        }
        
        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()
            
            addRequired(key: .name, value: name)
            
            add(key: .name, value: name)
            add(key: .customid, value: customid)
            add(key: .description, value: description)
            add(key: .moderation, value: moderation)
            add(key: .enableactions, value: enableactions)
            add(key: .enableenterandexit, value: enableenterandexit)
            add(key: .enableprofanityfilter, value: enableprofanityfilter)
            add(key: .roomisopen, value: roomisopen)
            add(key: .maxreports, value: maxreports)
            
            return toDictionary
        }
    }
    
    /// Get the details for a room
    ///
    /// roomIdOrSlug: Room Id or Slug of a specific room againts which you want to fetch the details
    ///
    /// - Warning: This method requires authentication.
    public class GetRoomDetails: ParametersBase<GetRoomDetails.Fields, GetRoomDetails> {
        public enum Fields {
            case roomIdOrSlug
        }
        
        public var roomid: String?
        
        override public func from(dictionary: [AnyHashable: Any]) -> GetRoomDetails {
            set(dictionary: dictionary)
            let ret = GetRoomDetails()
            
            ret.roomid = value(forKey: .roomIdOrSlug)
            
            return ret
        }
        
        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()
            
            addRequired(key: .roomIdOrSlug, value: roomid)
            
            return toDictionary
        }
    }
    
    
    /// Deletes the specified room and all events contained therein) by ID
    ///
    /// roomid: that you want to delete
    ///
    /// - Warning: This method requires authentication.
    public class DeleteRoom: ParametersBase<DeleteRoom.Fields, DeleteRoom> {
        public enum Fields {
            case roomid
        }
        
        public var roomid: String?
        public var userid: String?
        
        override public func from(dictionary: [AnyHashable: Any]) -> DeleteRoom {
            set(dictionary: dictionary)
            let ret = DeleteRoom()
            ret.roomid = value(forKey: .roomid)
            
            return ret
        }
        
        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()
            
            add(key: .roomid, value: roomid)
            addRequired(key: .roomid, value: roomid)
            
            return toDictionary
        }
    }
    
    /// Updates an existing room
    ///
    /// roomid: (required) The ID of the existing room
    ///
    /// slug: (optional) The URL friendly name of the room
    ///
    /// name: (optional) The name of the room
    ///
    /// description: (optional) The description of the room
    ///
    /// moderation: (optional) [premoderation/postmoderation] Defaults to post-moderation.
    ///
    /// enableactions: (optional) [true/false] Turns action commands on or off
    ///
    /// enableenterandexit: (optional) [true/false] Turn enter and exit events on or off. Disable for large rooms to reduce noise.
    ///
    /// enableprofanityfilter: (optional) [default=true / false] Enables profanity filtering.
    ///
    /// delaymessageseconds: (optional) [default=0] Puts a delay on messages from when they are submitted until they show up in the chat. Used for throttling.
    ///
    /// roomisopen: (optional) [true/false] If false, users cannot perform any commands in the room, chat is suspended.
    ///
    /// throttle: (optional) Defaults to 0. This is the number of seconds to delay new incomming messags so that the chat room doesn't scroll messages too fast.
    ///
    /// userid:  user id specific to App
    ///
    /// - Warning: This method requires authentication.
    public class UpdateRoom: ParametersBase<UpdateRoom.Fields, UpdateRoom> {
        public enum Fields {
            case roomid
            case slug
            case name
            case description
            case moderation
            case enableactions
            case enableenterandexit
            case enableprofanityfilter
            case delaymessageseconds
            case roomisopen
            case throttle
            case userid
        }
        
        public var roomid: String?
        public var slug: URL?
        public var name: String?
        public var description: String?
        public var moderation: String?
        public var enableactions: Bool?
        public var enableenterandexit: Bool?
        public var enableprofanityfilter: Bool?
        public var delaymessageseconds: Int?
        public var roomisopen:Bool?
        public var throttle:Int?
        public var userid:String?
        
        override public func from(dictionary: [AnyHashable: Any]) -> UpdateRoom {
            set(dictionary: dictionary)
            let ret = UpdateRoom()
            
            ret.roomid = value(forKey: .roomid)
            ret.slug = value(forKey: .slug)
            ret.name = value(forKey: .name)
            ret.description = value(forKey: .description)
            ret.moderation = value(forKey: .moderation)
            ret.enableactions = value(forKey: .enableactions)
            ret.enableenterandexit = value(forKey: .enableenterandexit)
            ret.enableprofanityfilter = value(forKey: .enableprofanityfilter)
            ret.roomisopen = value(forKey: .roomisopen)
            ret.delaymessageseconds = value(forKey: .delaymessageseconds)
            ret.throttle = value(forKey: .throttle)
            ret.userid = value(forKey: .userid)
            
            return ret
        }
        
        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()
            
            addRequired(key: .roomid, value: roomid)
            add(key: .roomid, value: roomid)
            add(key: .slug, value: slug?.absoluteString)
            add(key: .name, value: name)
            add(key: .description, value: description)
            add(key: .moderation, value: moderation)
            add(key: .enableactions, value: enableactions)
            add(key: .enableenterandexit, value: enableenterandexit)
            add(key: .enableprofanityfilter, value: enableprofanityfilter)
            add(key: .roomisopen, value: roomisopen)
            add(key: .delaymessageseconds, value: delaymessageseconds)
            add(key: .throttle, value: throttle)
            add(key: .userid, value: userid)
            
            return toDictionary
        }
    }
    
    /// Update Room (Close a room)
    ///
    /// roomid: (required) The ID of the existing room
    ///
    /// slug: (optional) The URL friendly name of the room
    ///
    /// name: (optional) The name of the room
    ///
    /// description: (optional) The description of the room
    ///
    /// moderation: (optional) [premoderation/postmoderation] Defaults to post-moderation.
    ///
    /// enableactions: (optional) [true/false] Turns action commands on or off
    ///
    /// enableenterandexit: (optional) [true/false] Turn enter and exit events on or off. Disable for large rooms to reduce noise.
    ///
    /// enableprofanityfilter: (optional) [default=true / false] Enables profanity filtering.
    ///
    /// delaymessageseconds: (optional) [default=0] Puts a delay on messages from when they are submitted until they show up in the chat. Used for throttling.
    ///
    /// roomisopen: (optional) [true/false] If false, users cannot perform any commands in the room, chat is suspended.
    ///
    /// userid:  user id specific to App
    ///
    /// - Warning: This method requires authentication.
    public class UpdateRoomCloseARoom: ParametersBase<UpdateRoomCloseARoom.Fields, UpdateRoomCloseARoom> {
        public enum Fields {
            case roomid
            case slug
            case name
            case description
            case moderation
            case enableactions
            case enableenterandexit
            case enableprofanityfilter
            case delaymessageseconds
            case roomisopen
            case userid
        }
        
        public var roomid: String?
        public var slug: URL?
        public var name: String?
        public var description: String?
        public var moderation: String?
        public var enableactions: Bool?
        public var enableenterandexit: Bool?
        public var enableprofanityfilter: Bool?
        public var delaymessageseconds: Int?
        public var roomisopen:Bool? = false
        public var userid:String?
        
        override public func from(dictionary: [AnyHashable: Any]) -> UpdateRoomCloseARoom {
            set(dictionary: dictionary)
            let ret = UpdateRoomCloseARoom()
            
            ret.roomid = value(forKey: .roomid)
            ret.slug = value(forKey: .slug)
            ret.name = value(forKey: .name)
            ret.description = value(forKey: .description)
            ret.moderation = value(forKey: .moderation)
            ret.enableactions = value(forKey: .enableactions)
            ret.enableenterandexit = value(forKey: .enableenterandexit)
            ret.enableprofanityfilter = value(forKey: .enableprofanityfilter)
            ret.roomisopen = value(forKey: .roomisopen)
            ret.delaymessageseconds = value(forKey: .delaymessageseconds)
            ret.userid = value(forKey: .userid)
            
            return ret
        }
        
        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()
            
            add(key: .roomid, value: roomid)
            add(key: .slug, value: slug?.absoluteString)
            add(key: .name, value: name)
            add(key: .description, value: description)
            add(key: .moderation, value: moderation)
            add(key: .enableactions, value: enableactions)
            add(key: .enableenterandexit, value: enableenterandexit)
            add(key: .enableprofanityfilter, value: enableprofanityfilter)
            add(key: .roomisopen, value: roomisopen)
            add(key: .delaymessageseconds, value: delaymessageseconds)
            add(key: .userid, value: userid)
            
            return toDictionary
        }
    }
    
    /// List all the available public chat rooms
    ///
    /// Rooms can be public or private. This method lists all public rooms that everyone can see.
    ///
    /// - Warning: This method requires authentication.
    public class ListRooms {
        public init() { }
        
        public func from(dictionary: [AnyHashable: Any]) -> ListRooms {
            let ret = ListRooms()
            return ret
        }
        
        public func toDictionary() -> [AnyHashable: Any] {
            return [AnyHashable: Any]()
        }
    }
    
    /// Join A Room
    ///
    /// You can join a room either by using the room ID or label. First this method attempts to join a room with the specified ID. If the ID is not found, it attempts to join using the specified label. Labels must be URL friendly. The label is provided when the room is created. For example, if you wanted to label the room with the ID of a match, you can join the room without the need to invoke list rooms to get a room id.
    ///
    /// Logged in users:
    ///  * To log a user in, provide a unique user ID string and chat handle string. If this is the first time the user ID has been used a new user record will be created for the user. Whenever the user creates an event in the room by doing an action like saying something, the user information will be returned.
    ///  * You can optionally also provide a URL to an image and a URL to a profile.
    ///  * If you provide user information and the user already exists in the database, the user will be updated with the new information.
    ///  * The user will be added to the list of participants in the room and the room participant count will increase.
    ///  * The user will be removed from the room automatically after some time if the user doesn't perform any operations.
    ///  * Users can only execute commands in the room if they have joined the room.
    ///  * When a logged in user joins a room an entrance event is generated in the room.
    ///  * When a logged in user leaves a room, an exit event is generated in the room.
    ///
    ///  Arguments:
    ///
    ///  roomid: (required) The room you want to join
    ///
    ///  userid: user id specific to App
    ///
    ///  handle: user handle specific to App
    ///
    ///  displayname: Display Name for user
    ///
    ///  pictureurl:  Picture url of user
    ///
    ///  profileurl: Profile url of user
    ///
    /// - Warning: This method requires authentication.
    public class JoinRoom: ParametersBase<JoinRoom.Fields, JoinRoom> {
        public enum Fields {
            case roomid
            case userid
            case handle
            case displayname
            case pictureurl
            case profileurl
        }
        
        public var roomid: String?
        public var userid: String?
        public var handle: String?
        public var displayname: String?
        public var pictureurl: URL?
        public var profileurl: URL?
        
        override public func from(dictionary: [AnyHashable: Any]) -> JoinRoom {
            set(dictionary: dictionary)
            let ret = JoinRoom()
            
            ret.roomid = value(forKey: .roomid)
            ret.userid = value(forKey: .userid)
            ret.handle = value(forKey: .handle)
            ret.displayname = value(forKey: .displayname)
            ret.pictureurl = value(forKey: .pictureurl)
            ret.profileurl = value(forKey: .profileurl)
            
            return ret
        }
        
        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()
            
            addRequired(key: .roomid, value: roomid)
            add(key: .userid, value: userid)
            add(key: .handle, value: handle)
            add(key: .displayname, value: displayname)
            add(key: .pictureurl, value: pictureurl?.absoluteString)
            add(key: .profileurl, value: profileurl?.absoluteString)
            
            return toDictionary
        }
    }
    
    /// Join A Room (By Custom Id)
    ///
    /// This method is the same as Join Room, except you can use your customid
    ///
    /// The benefit of this method is you don't need to query to get the roomid using customid, and then make another call to join the room. This eliminates a request and enables you to bring your chat experience to your user faster.
    ///
    /// Logged in users:
    ///  * To log a user in, provide a unique user ID string and chat handle string. If this is the first time the user ID has been used a new user record will be created for the user. Whenever the user creates an event in the room by doing an action like saying something, the user information will be returned.
    ///  * You can optionally also provide a URL to an image and a URL to a profile.
    ///  * If you provide user information and the user already exists in the database, the user will be updated with the new information.
    ///  * The user will be added to the list of participants in the room and the room participant count will increase.
    ///  * The user will be removed from the room automatically after some time if the user doesn't perform any operations.
    ///  * Users can only execute commands in the room if they have joined the room.
    ///  * When a logged in user joins a room an entrance event is generated in the room.
    ///  * When a logged in user leaves a room, an exit event is generated in the room.
    ///
    ///  Arguments:
    ///
    ///  customid: your custom id
    ///
    ///  userid: user id specific to App
    ///
    ///  handle: user handle specific to App
    ///
    ///  displayname: Display Name for user
    ///
    ///  pictureurl:  Picture url of user
    ///
    ///  profileurl: Profile url of user
    ///
    /// - Warning: This method requires authentication.
    public class JoinRoomByCustomId: ParametersBase<JoinRoomByCustomId.Fields, JoinRoomByCustomId> {
       public enum Fields {
           case customid
           case userid
           case handle
           case displayname
           case pictureurl
           case profileurl
       }
       
       public var customid: String?
       public var userid: String?
       public var handle: String?
       public var displayname: String?
       public var pictureurl: URL?
       public var profileurl: URL?
       
       override public func from(dictionary: [AnyHashable: Any]) -> JoinRoomByCustomId {
           set(dictionary: dictionary)
           let ret = JoinRoomByCustomId()
           
           ret.customid = value(forKey: .customid)
           ret.userid = value(forKey: .userid)
           ret.handle = value(forKey: .handle)
           ret.displayname = value(forKey: .displayname)
           ret.pictureurl = value(forKey: .pictureurl)
           ret.profileurl = value(forKey: .profileurl)
           
           return ret
       }
       
       public func toDictionary() -> [AnyHashable: Any] {
           toDictionary = [AnyHashable: Any]()
           
           addRequired(key: .customid, value: customid)
           addRequired(key: .userid, value: userid)
           add(key: .handle, value: handle)
           add(key: .displayname, value: displayname)
           add(key: .pictureurl, value: pictureurl?.absoluteString)
           add(key: .profileurl, value: profileurl?.absoluteString)
           
           return toDictionary
       }
    }

    
    /// List all the participants in the specified room
    ///
    /// Use this method to cursor through the people who have subscribe to the room.
    ///
    /// To cursor through the results if there are many participants, invoke this function many times. Each result will return a cursor value and you can pass that value to the next invokation to get the next page of results. The result set will also include a next field with the full URL to get the next page, so you can just keep reading that and requesting that URL until you reach the end. When you reach the end, no more results will be returned or the result set will be less than maxresults and the next field will be empty.
    ///
    ///  Arguments:
    ///
    ///  roomid:  room id that you want to list the participants
    ///
    ///  cursor:  you can pass that value to the next invokation to get the next page of results
    ///
    ///  limit: default is 200
    ///
    /// - Warning: This method requires authentication.
    public class ListRoomParticipants: ParametersBase<ListRoomParticipants.Fields, ListRoomParticipants> {
        public enum Fields {
            case roomid
            case cursor
            case limit
        }
        
        public var roomid: String?
        public var cursor: String? = ""
        public var limit: Int? = 200
        
        override public func from(dictionary: [AnyHashable: Any]) -> ListRoomParticipants {
            set(dictionary: dictionary)
            let ret = ListRoomParticipants()
            ret.roomid = value(forKey: .roomid)
            ret.cursor = value(forKey: .cursor)
            ret.limit = value(forKey: .limit)
            
            return ret
        }
        
        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()
            
            add(key: .cursor, value: cursor)
            add(key: .limit, value: limit)
            
            return toDictionary
        }
    }
    
    /// Exit a Room
    ///
    ///  Arguments:
    ///
    ///  roomid:  Room id that you want to exit
    ///
    ///  userid:  user id specific to App
    ///
    /// - Warning: This method requires authentication.
    public class ExitRoom: ParametersBase<ExitRoom.Fields, ExitRoom> {
        public enum Fields {
            case roomid
            case userid
        }
        
        public var roomid: String?
        public var userid: String?
        
        override public func from(dictionary: [AnyHashable: Any]) -> ExitRoom {
            set(dictionary: dictionary)
            let ret = ExitRoom()
            
            ret.roomid = value(forKey: .roomid)
            ret.userid = value(forKey: .userid)
            
            return ret
        }
        
        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()
            
            addRequired(key: .roomid, value: roomid)
            add(key: .userid, value: userid)
            
            return toDictionary
        }
    }
    
    
    /// Get the Recent Updates to a Room
    ///
    /// You can use this function to poll the room to get the recent events in the room. The recommended poll interval is 500ms. Each event has an ID and a timestamp. To detect new messages using polling, call this function and then process items with a newer timestamp than the most recent one you have already processed.
    ///
    /// Each event in the stream has a KIND property. Inspect the property to determine if it is a... enter event: A user has joined the room.
    ///
    /// exit event: A user has exited chat. message: A user has communicated a message. reply: A user sent a message in response to another user. reaction: A user has reacted to a message posted by another user. action: A user is performing an ACTION (emote) alone or with another user.
    ///
    ///  Enter and Exit Events:
    ///
    ///  Enter and Exit events may not be sent if the room is expected to have a very large number of users.
    ///
    ///  Arguments:
    ///
    ///  roomid:  Room id that you want to update
    ///
    ///  cursor:  Used in cursoring through the list. Gets the next batch of users. Read 'nextCur' property of result set and pass as cursor value.
    ///
    /// - Warning: This method requires authentication.
    public class GetUpdates: ParametersBase<GetUpdates.Fields, GetUpdates> {
        public enum Fields {
            case roomid
            case cursor
        }
        
        public var roomid: String?
        public var cursor: String?
        
        override public func from(dictionary: [AnyHashable: Any]) -> GetUpdates {
            set(dictionary: dictionary)
            let ret = GetUpdates()
            
            ret.roomid = value(forKey: .roomid)
            ret.cursor = value(forKey: .cursor)
            
            return ret
        }
        
        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()
            
            addRequired(key: .roomid, value: roomid)
            add(key: .cursor, value: cursor)
            
            return toDictionary
        }
    }
    
    /// Executes a command in a chat room
    ///
    /// SENDING A MESSAGE:
    ///
    ///  * Send any text that doesn't start with a reserved symbol to perform a SAY command.
    ///  * Use this API call to REPLY to existing messages
    ///  * Use this API call to perform ACTION commands
    ///  * Use this API call to perform ADMIN commands
    ///
    ///  example:
    ///  These commands both do the same thing, which is send the message "Hello World" to the room. SAY Hello, World Hello, World
    ///
    ///  ACTION COMMANDS:
    ///
    ///  * Action commands start with the / character
    ///
    /// example:
    ///
    /// /dance nicole User sees:
    /// You dance with Nicole
    /// Nicole sees: (user's handle) dances with you
    /// Everyone else sees: (user's handle) dances with Nicoel
    ///
    /// This requires that the action command dance is on the approved list of commands and Nicole is the handle of a participant in the room, and that actions are allowed in the room.
    ///
    /// ADMIN COMMANDS:
    ///
    ///  * These commands start with the * character
    /// Each event in the stream has a KIND property. Inspect the property to determine if it is a... enter event: A user has joined the room.
    ///
    /// example:
    ///
    ///  * ban : This bans the user from the entire chat experience (all rooms).
    ///  * restore : This restores the user to the chat experience (all rooms).
    ///  * purge : This deletes all messages from the specified user.
    ///  * deleteallevents : This deletes all messages in this room.
    ///
    ///  SENDING A REPLY::
    ///
    ///   * replyto:  Use this field to provide the EventID of an event you want to reply to. Replies have a different event type and contain a copy of the original event.
    ///
    ///  Arguments:
    ///
    ///  command:  command that you want to pass
    ///
    ///  userid: user id specific to App
    ///
    ///  customtype: any type you want to save
    ///
    ///  customid: any custom id you want to pass
    ///
    ///  custompayload: any payload.
    ///
    /// - Warning: This method requires authentication.
    public class ExecuteChatCommand: ParametersBase<ExecuteChatCommand.Fields, ExecuteChatCommand> {
        public enum Fields {
            case roomid
            case command
            case userid
            case customtype
            case customid
            case custompayload
        }
        
        public var roomid: String?
        public var command: String?
        public var userid: String?
        public var customtype: String?
        public var customid: String?
        public var custompayload: String?
        
        override public func from(dictionary: [AnyHashable: Any]) -> ExecuteChatCommand {
            set(dictionary: dictionary)
            let ret = ExecuteChatCommand()
            
            ret.roomid = value(forKey: .roomid)
            ret.command = value(forKey: .command)
            ret.userid = value(forKey: .userid)
            ret.customtype = value(forKey: .customtype)
            ret.customid = value(forKey: .customid)
            ret.custompayload = value(forKey: .custompayload)
            
            return ret
        }
        
        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()
            
            addRequired(key: .roomid, value: roomid)
            add(key: .command, value: command)
            add(key: .userid, value: userid)
            add(key: .customtype, value: customtype)
            add(key: .customid, value: customid)
            add(key: .custompayload, value: custompayload)
            
            return toDictionary
        }
    }
    
    /// Executes a command in a chat room
    ///
    /// SENDING A MESSAGE:
    ///
    ///  * Send any text that doesn't start with a reserved symbol to perform a SAY command.
    ///  * Use this API call to REPLY to existing messages
    ///  * Use this API call to perform ACTION commands
    ///  * Use this API call to perform ADMIN commands
    ///
    ///  example:
    ///  These commands both do the same thing, which is send the message "Hello World" to the room. SAY Hello, World Hello, World
    ///
    ///  ACTION COMMANDS:
    ///
    ///  * Action commands start with the / character
    ///
    /// example:
    ///
    /// /dance nicole User sees:
    /// You dance with Nicole
    /// Nicole sees: (user's handle) dances with you
    /// Everyone else sees: (user's handle) dances with Nicoel
    ///
    /// This requires that the action command dance is on the approved list of commands and Nicole is the handle of a participant in the room, and that actions are allowed in the room.
    ///
    /// ADMIN COMMANDS:
    ///
    ///  * These commands start with the * character
    /// Each event in the stream has a KIND property. Inspect the property to determine if it is a... enter event: A user has joined the room.
    ///
    /// example:
    ///
    ///  * ban : This bans the user from the entire chat experience (all rooms).
    ///  * restore : This restores the user to the chat experience (all rooms).
    ///  * purge : This deletes all messages from the specified user.
    ///  * deleteallevents : This deletes all messages in this room.
    ///
    ///  SENDING A REPLY::
    ///
    ///   * replyto:  Use this field to provide the EventID of an event you want to reply to. Replies have a different event type and contain a copy of the original event.
    ///
    ///  Arguments:
    ///
    ///  command:  command that you want to pass
    ///
    ///  userid: user id specific to App
    ///
    ///  customtype: any type you want to save
    ///
    ///  customid: any custom id you want to pass
    ///
    ///  custompayload: any payload.
    ///
    /// - Warning: This method requires authentication.
    public class ExecuteDanceAction: ParametersBase<ExecuteDanceAction.Fields, ExecuteDanceAction> {
        public enum Fields {
            case roomid
            case command
            case userid
            case customtype
            case customid
            case custompayload
        }
        
        public var roomid: String?
        public var command: String?
        public var userid: String?
        public var customtype: String?
        public var customid: String?
        public var custompayload: String?
        
        override public func from(dictionary: [AnyHashable: Any]) -> ExecuteDanceAction {
            set(dictionary: dictionary)
            let ret = ExecuteDanceAction()
            
            ret.roomid = value(forKey: .roomid)
            ret.command = value(forKey: .command)
            ret.userid = value(forKey: .userid)
            ret.customtype = value(forKey: .customtype)
            ret.customid = value(forKey: .customid)
            ret.custompayload = value(forKey: .custompayload)
            
            return ret
        }
        
        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()
            
            addRequired(key: .roomid, value: roomid)
            add(key: .command, value: command)
            add(key: .userid, value: userid)
            add(key: .customtype, value: customtype)
            add(key: .customid, value: customid)
            add(key: .custompayload, value: custompayload)
            
            return toDictionary
        }
    }
    
    /// Executes a command in a chat room
    ///
    /// SENDING A MESSAGE:
    ///
    ///  * Send any text that doesn't start with a reserved symbol to perform a SAY command.
    ///  * Use this API call to REPLY to existing messages
    ///
    ///  example:
    ///  These commands both do the same thing, which is send the message "Hello World" to the room. SAY Hello, World Hello, World
    ///
    ///  ACTION COMMANDS:
    ///
    ///  * Action commands start with the / character
    ///
    /// example:
    ///
    /// /dance nicole User sees:
    /// You dance with Nicole
    /// Nicole sees: (user's handle) dances with you
    /// Everyone else sees: (user's handle) dances with Nicoel
    ///
    /// This requires that the action command dance is on the approved list of commands and Nicole is the handle of a participant in the room, and that actions are allowed in the room.
    ///
    /// ADMIN COMMANDS:
    ///
    ///  * These commands start with the * character
    /// Each event in the stream has a KIND property. Inspect the property to determine if it is a... enter event: A user has joined the room.
    ///
    /// example:
    ///
    ///  * ban : This bans the user from the entire chat experience (all rooms).
    ///  * restore : This restores the user to the chat experience (all rooms).
    ///  * purge : This deletes all messages from the specified user.
    ///  * deleteallevents : This deletes all messages in this room.
    ///
    ///  SENDING A REPLY::
    ///
    ///   * replyto:  Use this field to provide the EventID of an event you want to reply to. Replies have a different event type and contain a copy of the original event.
    ///
    ///  Arguments:
    ///
    ///  command:  command that you want to pass
    ///
    ///  userid: user id specific to App
    ///
    ///  customtype: any type you want to save
    ///
    ///  customid: any custom id you want to pass
    ///
    ///  custompayload: any payload.
    ///
    /// - Warning: This method requires authentication.
    public class SendQuotedReply: ParametersBase<SendQuotedReply.Fields, SendQuotedReply> {
        public enum Fields {
            case roomid
            case command
            case userid
            case replyto
        }
        
        public var roomid: String?
        public var command: String?
        public var userid: String?
        public var replyto: String?
        
        override public func from(dictionary: [AnyHashable: Any]) -> SendQuotedReply {
            set(dictionary: dictionary)
            let ret = SendQuotedReply()
            
            ret.roomid = value(forKey: .roomid)
            ret.command = value(forKey: .command)
            ret.userid = value(forKey: .userid)
            ret.replyto = value(forKey: .replyto)
            
            return ret
        }
        
        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()
            
            addRequired(key: .roomid, value: roomid)
            add(key: .command, value: command)
            add(key: .userid, value: userid)
            add(key: .replyto, value: replyto)
            
            return toDictionary
        }
    }
    
    /// Executes a command in a chat room
    ///
    /// SENDING A MESSAGE:
    ///
    ///  * Send any text that doesn't start with a reserved symbol to perform a SAY command.
    ///  * Use this API call to REPLY to existing messages
    ///
    ///  example:
    ///  These commands both do the same thing, which is send the message "Hello World" to the room. SAY Hello, World Hello, World
    ///
    ///  ACTION COMMANDS:
    ///
    ///  * Action commands start with the / character
    ///
    /// example:
    ///
    /// /dance nicole User sees:
    /// You dance with Nicole
    /// Nicole sees: (user's handle) dances with you
    /// Everyone else sees: (user's handle) dances with Nicoel
    ///
    /// This requires that the action command dance is on the approved list of commands and Nicole is the handle of a participant in the room, and that actions are allowed in the room.
    ///
    /// ADMIN COMMANDS:
    ///
    ///  * These commands start with the * character
    /// Each event in the stream has a KIND property. Inspect the property to determine if it is a... enter event: A user has joined the room.
    ///
    /// example:
    ///
    ///  * ban : This bans the user from the entire chat experience (all rooms).
    ///  * restore : This restores the user to the chat experience (all rooms).
    ///  * purge : This deletes all messages from the specified user.
    ///  * deleteallevents : This deletes all messages in this room.
    ///
    ///  SENDING A REPLY::
    ///
    ///   * replyto:  Use this field to provide the EventID of an event you want to reply to. Replies have a different event type and contain a copy of the original event.
    ///
    ///  Arguments:
    ///
    ///  command:  command that you want to pass
    ///
    ///  userid: user id specific to App
    ///
    ///  customtype: any type you want to save
    ///
    ///  customid: any custom id you want to pass
    ///
    ///  custompayload: any payload.
    ///
    /// - Warning: This method requires authentication.
    public class SendThreadedReply: ParametersBase<SendThreadedReply.Fields, SendThreadedReply> {
        public enum Fields {
            case roomid
            case command
            case userid
            case replyto
        }
        
        public var roomid: String?
        public var command: String?
        public var userid: String?
        public var replyto: String?
        
        override public func from(dictionary: [AnyHashable: Any]) -> SendThreadedReply {
            set(dictionary: dictionary)
            let ret = SendThreadedReply()
            
            ret.roomid = value(forKey: .roomid)
            ret.command = value(forKey: .command)
            ret.userid = value(forKey: .userid)
            ret.replyto = value(forKey: .replyto)
            
            return ret
        }
        
        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()
            
            addRequired(key: .roomid, value: roomid)
            add(key: .command, value: command)
            add(key: .userid, value: userid)
            add(key: .replyto, value: replyto)
            
            return toDictionary
        }
    }
    
    /// Gets a list of users messages
    ///
    /// The purpose of this method is to get a list of messages or comments by a user, with count of replies and reaction data. This way, you can easily make a screen in your application that shows the user a list of their comment contributions and how people reacted to it.
    ///
    ///  Arguments:
    ///
    ///  roomid:  Room id, in which you want to fetch messages
    ///
    ///  userid:  user id, against which you want to fetch messages
    ///
    ///  cursor:  Used in cursoring through the list. Gets the next batch of users. Read 'nextCur' property of result set and pass as cursor value.
    ///
    ///  limit: default 200
    ///
    /// - Warning: This method requires authentication.
    public class ListMessagesByUser: ParametersBase<ListMessagesByUser.Fields, ListMessagesByUser> {
        public enum Fields {
            case cursor
            case limit
            case userid
            case roomid
        }
        
        public var cursor: String?
        public var limit: String? = defaultLimit
        public var userId: String?
        public var roomid: String?
        
        override public func from(dictionary: [AnyHashable: Any]) -> ListMessagesByUser {
            set(dictionary: dictionary)
            let ret = ListMessagesByUser()
            
            ret.cursor = value(forKey: .cursor)
            ret.limit = value(forKey: .limit)
            ret.userId = value(forKey: .userid)
            ret.roomid = value(forKey: .roomid)
            return ret
        }
        
        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()
            
            add(key: .cursor, value: cursor)
            add(key: .limit, value: limit)
            add(key: .roomid, value: roomid)
            addRequired(key: .userid, value: userId)
            
            return toDictionary
        }
    }
    
    /// Removes a message from a room.
    ///
    /// This does not DELETE the message. It flags the message as moderator removed.
    ///
    ///  Arguments:
    ///
    ///  chatRoomId:  Room id, in which you want to remove the message
    ///
    ///  chatMessageId:  the message you want to remove
    ///
    /// - Warning: This method requires authentication.
    public class PermanentlyDeleteEvent: ParametersBase<PermanentlyDeleteEvent.Fields, PermanentlyDeleteEvent> {
        public enum Fields {
            case roomid
            case eventid
            case userid
        }
        
        public var roomid: String!
        public var eventid: String!
        public var userid: String!
        public var deleted: Bool = true
        public var permanent: Bool = true
        
        override public func from(dictionary: [AnyHashable: Any]) -> PermanentlyDeleteEvent {
            set(dictionary: dictionary)
            let ret = PermanentlyDeleteEvent()
            
            ret.roomid = value(forKey: .roomid)
            ret.eventid = value(forKey: .eventid)
            ret.userid = value(forKey: .userid)
            ret.deleted = true
            ret.permanent = true
            
            return ret
        }
        
        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()
            
            addRequired(key: .roomid, value: roomid)
            addRequired(key: .eventid, value: eventid)
            addRequired(key: .userid, value: userid)
            
            return toDictionary
        }
    }
    
    
    /// Executes a command in a chat room to purge all messages for a user
    ///
    /// This does not DELETE the message. It flags the message as moderator removed.
    ///
    ///  Arguments:
    ///
    ///  command: The command to execute. In this case, "*purge "
    ///
    ///  userid:  user id specific to app
    ///
    ///  chatroomid: room id, against which you want to purge the messages
    ///
    /// - Warning: This method requires authentication.
    public class PurgeUserMessages: ParametersBase<PurgeUserMessages.Fields, PurgeUserMessages> {
        public enum Fields {
            case command
            case chatroomid
            case userid
        }
        
        public var userid: String?
        public var chatroomid: String?
        public var command: String?
        
        override public func from(dictionary: [AnyHashable: Any]) -> PurgeUserMessages {
            set(dictionary: dictionary)
            let ret = PurgeUserMessages()
            
            ret.userid = value(forKey: .userid)
            ret.chatroomid = value(forKey: .chatroomid)
            ret.command = value(forKey: .command)
            
            return ret
        }
        
        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()
            
            addRequired(key: .chatroomid, value: chatroomid)
            add(key: .userid, value: userid)
            add(key: .command, value: command)
            
            return toDictionary
        }
    }
    
    
    /// REPORTS a message to the moderation team
    ///
    /// A reported message is temporarily removed from the chat event stream until it is evaluated by a moderator.
    ///
    ///  Arguments:
    ///
    ///  reporttype:  e.g. abuse
    ///
    ///  userid:  user id specific to app
    ///
    ///  chatRoomId: Room Id, in which you want to report the message
    ///
    ///  chatMessageId: message id, that you want to report.
    ///
    /// - Warning: This method requires authentication.
    public class ReportMessage: ParametersBase<ReportMessage.Fields, ReportMessage> {
        public enum Fields {
            case chatRoomId
            case chatMessageId
            case chat_room_newest_speech_id
            case userid
            case reporttype
        }
        
        public var chatRoomId: String?
        public var chatMessageId: String?
        public var chat_room_newest_speech_id: String?
        public var userid: String?
        public var reporttype = "abuse"
        
        override public func from(dictionary: [AnyHashable: Any]) -> ReportMessage {
            set(dictionary: dictionary)
            let ret = ReportMessage()
            
            ret.chatRoomId = value(forKey: .chatRoomId)
            ret.chatMessageId = value(forKey: .chatMessageId)
            ret.chat_room_newest_speech_id = value(forKey: .chat_room_newest_speech_id)
            ret.userid = value(forKey: .userid)
            ret.reporttype = value(forKey: .reporttype) ?? "abuse"
            
            return ret
        }
        
        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()
            
            addRequired(key: .userid, value: userid)
            addRequired(key: .reporttype, value: reporttype)
            
            return toDictionary
        }
    }
    
    
    /// React To Event
    ///
    /// Adds or removes a reaction to an existing event
    ///
    /// After this completes, a new event appears in the stream representing the reaction. The new event will have an updated version of the event in the replyto field, which you can use to update your UI.
    ///
    ///  Arguments:
    ///
    ///  userid:  user id specific to app
    ///
    ///  roomId: Room Id, in which you want to react
    ///
    ///  roomNewestEventId: message id, that you want to report.
    ///
    ///  reacted: true/false
    ///
    ///  reaction: e.g. like
    ///
    /// - Warning: This method requires authentication.
    public class ReactToEvent: ParametersBase<ReactToEvent.Fields, ReactToEvent> {
        public enum Fields {
            case roomid
            case eventid
            case userid
            case reaction
            case reacted
        }
        
        public var roomid: String?
        public var eventid: String?
        public var userid: String?
        public var reaction: String?
        public var reacted: String? = "true"
        
        override public func from(dictionary: [AnyHashable: Any]) -> ReactToEvent {
            set(dictionary: dictionary)
            let ret = ReactToEvent()
            
            ret.roomid = value(forKey: .roomid)
            ret.eventid = value(forKey: .eventid)
            ret.userid = value(forKey: .userid)
            ret.reaction = value(forKey: .reaction)
            ret.reacted = value(forKey: .reacted)
            
            return ret
        }
        
        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()
            
            addRequired(key: .roomid, value: roomid)
            addRequired(key: .eventid, value: eventid)
            add(key: .userid, value: userid)
            add(key: .reaction, value: reaction)
            add(key: .reacted, value: reacted)
            
            return toDictionary
        }
    }
    
    ///  Execute Admin Command (*help)
    ///
    /// SENDING A MESSAGE:
    ///
    ///  * Send any text that doesn't start with a reserved symbol to perform a SAY command.
    ///  * Use this API call to REPLY to existing messages
    ///
    ///  example:
    ///  These commands both do the same thing, which is send the message "Hello World" to the room. SAY Hello, World Hello, World
    ///
    ///  ACTION COMMANDS:
    ///
    ///  * Action commands start with the / character
    ///
    /// example:
    ///
    /// /dance nicole User sees:
    /// You dance with Nicole
    /// Nicole sees: (user's handle) dances with you
    /// Everyone else sees: (user's handle) dances with Nicoel
    ///
    /// This requires that the action command dance is on the approved list of commands and Nicole is the handle of a participant in the room, and that actions are allowed in the room.
    ///
    /// ADMIN COMMANDS:
    ///
    ///  * These commands start with the * character
    /// Each event in the stream has a KIND property. Inspect the property to determine if it is a... enter event: A user has joined the room.
    ///
    /// example:
    ///
    ///  * *banuserhere nicole: This bans the user Nicole from this room.
    ///  * *banusereverywhere nicole: This bans user Nicole from all rooms.
    ///  * *deletemessageshere nicole: This deletes all messages by user Nicole in this room
    ///  * *deletemessageseverywhere nicole: This deletes all messages by user Nicole in all rooms
    ///
    ///  Arguments:
    ///
    ///  command:  command that you want to pass
    ///
    ///  userid: user id specific to App
    ///
    ///  customtype: any type you want to save
    ///
    ///  customid: any custom id you want to pass
    ///
    ///  custompayload: any payload.
    ///
    /// - Warning: This method requires authentication.
    public class ExecuteAdminCommand: ParametersBase<ExecuteAdminCommand.Fields, ExecuteAdminCommand> {
        public enum Fields {
            case roomId
            case command
            case userid
            case customtype
            case customid
            case custompayload
        }
        
        public var roomId: String?
        public var command: String?
        public var userid: String?
        public var customtype: String?
        public var customid: String?
        public var custompayload: String?
        
        override public func from(dictionary: [AnyHashable: Any]) -> ExecuteAdminCommand {
            set(dictionary: dictionary)
            let ret = ExecuteAdminCommand()
            
            ret.roomId = value(forKey: .roomId)
            ret.command = value(forKey: .command)
            ret.userid = value(forKey: .userid)
            ret.customtype = value(forKey: .customtype)
            ret.customid = value(forKey: .customid)
            ret.custompayload = value(forKey: .custompayload)
            
            return ret
        }
        
        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()
            
            addRequired(key: .roomId, value: roomId)
            add(key: .command, value: command)
            add(key: .userid, value: userid)
            add(key: .customtype, value: customtype)
            add(key: .customid, value: customid)
            add(key: .custompayload, value: custompayload)
            
            return toDictionary
        }
    }
    
    /// Executes a command in a chat room
    ///
    /// SENDING A MESSAGE:
    ///
    ///  * Send any text that doesn't start with a reserved symbol to perform a SAY command.
    ///  * Use this API call to REPLY to existing messages
    ///
    ///  example:
    ///  These commands both do the same thing, which is send the message "Hello World" to the room. SAY Hello, World Hello, World
    ///
    ///  ACTION COMMANDS:
    ///
    ///  * Action commands start with the / character
    ///
    /// example:
    ///
    /// /dance nicole User sees:
    /// You dance with Nicole
    /// Nicole sees: (user's handle) dances with you
    /// Everyone else sees: (user's handle) dances with Nicoel
    ///
    /// This requires that the action command dance is on the approved list of commands and Nicole is the handle of a participant in the room, and that actions are allowed in the room.
    ///
    /// ADMIN COMMANDS:
    ///
    ///  * These commands start with the * character
    /// Each event in the stream has a KIND property. Inspect the property to determine if it is a... enter event: A user has joined the room.
    ///
    /// example:
    ///
    ///  * ban : This bans the user from the entire chat experience (all rooms).
    ///  * restore : This restores the user to the chat experience (all rooms).
    ///  * purge : This deletes all messages from the specified user.
    ///  * deleteallevents : This deletes all messages in this room.
    ///
    ///  SENDING A REPLY::
    ///
    ///   * replyto:  Use this field to provide the EventID of an event you want to reply to. Replies have a different event type and contain a copy of the original event.
    ///
    ///  Arguments:
    ///
    ///  command:  command that you want to pass
    ///
    ///  userid: user id specific to App
    ///
    ///  customtype: any type you want to save
    ///
    ///  customid: any custom id you want to pass
    ///
    ///  custompayload: any payload.
    ///
    /// - Warning: This method requires authentication.
    public class DeleteAllEventsInRoom: ParametersBase<DeleteAllEventsInRoom.Fields, DeleteAllEventsInRoom> {
        public enum Fields {
            case command
            case chatroomid
            case userid
        }
        
        public var userid: String?
        public var chatroomid: String?
        public var command: String?
        
        override public func from(dictionary: [AnyHashable: Any]) -> DeleteAllEventsInRoom {
            set(dictionary: dictionary)
            let ret = DeleteAllEventsInRoom()
            
            ret.userid = value(forKey: .userid)
            ret.chatroomid = value(forKey: .chatroomid)
            ret.command = value(forKey: .command)
            
            return ret
        }
        
        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()
            
            addRequired(key: .chatroomid, value: chatroomid)
            add(key: .userid, value: userid)
            add(key: .command, value: command)
            
            return toDictionary
        }
    }
}

// MARK: - Event Subscription
extension ChatRequest {
    public class StartEventUpdates: ParametersBase<StartEventUpdates.Fields, StartEventUpdates> {
        public enum Fields {
            case roomId
        }
        
        public var roomId: String?

        override public func from(dictionary: [AnyHashable: Any]) -> StartEventUpdates {
            set(dictionary: dictionary)
            let ret = StartEventUpdates()
            ret.roomId = value(forKey: .roomId)
            return ret
        }
        
        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()
            addRequired(key: .roomId, value: roomId)
            return toDictionary
        }
    }
}