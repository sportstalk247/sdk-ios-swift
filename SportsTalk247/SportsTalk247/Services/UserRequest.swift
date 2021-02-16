import Foundation

public class UserRequest {
    
    /// All users must have a Handle. The display name is optional. If you create a user and don't provide a handle, but you do provide a display name, a handle will be generated for you based on the provided display name. The generated handle will not be able to contain all characters or spaces, and could have numbers appended to the end.
    ///
    /// Invoke this API method if you want to create a user or update an existing user.
    ///
    /// Do not use this method to convert an anonymous user into a known user. Use the Convert User api method instead.
    ///
    /// When users send messages to a room the user ID is passed as a parameter. When you retrieve the events from a room, the user who generated the event is returned with the event data, so it is easy for your application to process and render chat events with minimal code.
    ///
    /// **Parameters**
    ///
    /// - userid: (required) If the userid is new then the user will be created. If the userid is already in use in the database then the user will be updated.
    ///
    /// - handle: (optional) A unique string representing the user that is easy for other users to type. Example @GeorgeWashington could be the handle but Display Name could be "Wooden Teef For The Win".
    ///
    /// - displayname: (optional) This is the desired name to display, typically the real name of the person.
    ///
    /// - pictureurl: (optional) The URL to the picture for this user.
    ///
    /// - profileurl: (optional) The profileurl for this user.
    ///
    /// **Note about handles**
    /// 
    /// - If you are creating a user and you don't specify a handle, the system will generate one for you (using Display Name as basis if you provide that).
    ///
    /// - If you request a handle and it's already in use a new handle will be generated for you by adding a number from 1-99 and returned.
    ///
    /// - If the handle can't be generated because all the options 1-99 on the end of it are taken then the request will be rejected with BadRequest status code.
    ///
    /// - Only these characters may be used:
    ///     *"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_"*
    
    public class CreateUpdateUser: ParametersBase<CreateUpdateUser.Fields, CreateUpdateUser> {
        public enum Fields {
            case userid
            case handle
            case displayname
            case pictureurl
            case profileurl
        }

        public var userid: String?
        public var handle: String?
        public var displayname: String?
        public var pictureurl: URL?
        public var profileurl: URL?

        override public func from(dictionary: [AnyHashable: Any]) -> CreateUpdateUser {
            set(dictionary: dictionary)
            let ret = CreateUpdateUser()

            ret.userid = value(forKey: .userid)
            ret.handle = value(forKey: .handle)
            ret.displayname = value(forKey: .displayname)
            ret.pictureurl = value(forKey: .pictureurl)
            ret.profileurl = value(forKey: .profileurl)

            return ret
        }

        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()

            addRequired(key: .userid, value: userid)
            add(key: .handle, value: handle)
            add(key: .displayname, value: displayname)
            add(key: .pictureurl, value: pictureurl?.absoluteString)
            add(key: .profileurl, value: profileurl?.absoluteString)

            return toDictionary
        }
    }
    
    /// Deletes the specified user.
    ///
    /// All rooms with messages by that user will have the messages from this user purged in the rooms.
    ///
    /// **Parameters**
    ///
    /// - userid: (required) is the app specific User ID provided by your application.
    ///
    /// **Warning** This method requires authentication
    ///
    public class DeleteUser: ParametersBase<DeleteUser.Fields,DeleteUser> {
        public enum Fields {
            case userid
        }
        
        public var userid: String?
        
        override func from(dictionary: [AnyHashable : Any]) -> UserRequest.DeleteUser {
            set(dictionary: dictionary)
            let ret = DeleteUser()
            
            ret.userid = value(forKey: .userid)
            
            return ret
        }
        
        public func toDictionary() -> [AnyHashable : Any] {
            toDictionary = [AnyHashable: Any]()
            return toDictionary
        }
        
    }
    
    /// Get the details about a User.
    ///
    /// This will return all the information about the user.
    ///
    /// **Parameters**
    ///
    /// - userid: (required) is the app specific User ID provided by your application.
    ///
    /// **Warning** This method requires authentication
    ///
    public class GetUserDetails: ParametersBase<GetUserDetails.Fields, GetUserDetails> {
        public enum Fields {
            case userid
        }
        
        public var userid: String?

        override public func from(dictionary: [AnyHashable: Any]) -> GetUserDetails {
            set(dictionary: dictionary)
            let ret = GetUserDetails()
            ret.userid = value(forKey: .userid)

            return ret
        }

        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()
            return toDictionary
        }
    }
    
    /// Gets a list of users.
    ///
    /// Use this method to cursor through a list of users. This method will return users in the order in which they were created, so it is safe to add new users while cursoring through the list.
    ///
    /// **Parameters**
    ///
    /// - cursor: (optional) Each call to ListUsers will return a result set with a 'nextCursor' value. To get the next page of users, pass this value as the optional 'cursor' property. To get the first page of users, omit the 'cursor' argument.
    ///
    /// - limit: (optional) You can omit this optional argument, in which case the default limit is 200 users to return.
    ///
    /// **Warning** This method requires authentication
    ///
    public class ListUsers: ParametersBase<ListUsers.Fields, ListUsers> {
        public enum Fields {
            case cursor
            case limit
        }

        public var cursor: String?
        public var limit: Int? = 200

        override public func from(dictionary: [AnyHashable: Any]) -> ListUsers {
            set(dictionary: dictionary)
            let ret = ListUsers()

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
    
    /// Will toggle the user's banned flag.
    ///
    /// **Parameters**
    ///
    /// - userid: (required) The applicaiton provided userid of the user to ban
    ///
    /// - applyeffect: (required) Boolean. If true, user will be set to banned state. If false, will be set to non-banned state.
    ///
    public class SetBanStatus: ParametersBase<SetBanStatus.Fields, SetBanStatus> {
        public enum Fields {
            case userid
            case applyeffect
        }

        public var userid: String?
        public var applyeffect: Bool?
        
        override public func from(dictionary: [AnyHashable: Any]) -> SetBanStatus {
            set(dictionary: dictionary)
            let ret = SetBanStatus()

            ret.userid = value(forKey: .userid)
            ret.applyeffect = value(forKey: .applyeffect)
         
            return ret
        }

        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()

            add(key: .applyeffect, value: applyeffect)
            
            return toDictionary
        }
    }
    
    /// Will purge all chat content published by the specified user
    ///
    /// **Parameters**
    ///
    /// - userid: (required) The application provided userid of the user to ban
    ///
    public class GloballyPurgeUserContent: ParametersBase<GloballyPurgeUserContent.Fields, GloballyPurgeUserContent> {
        public enum Fields {
            case userid
            case banned
        }

        public var userid: String?
        public var banned: Bool?
        
        override public func from(dictionary: [AnyHashable: Any]) -> GloballyPurgeUserContent {
            set(dictionary: dictionary)
            let ret = GloballyPurgeUserContent()

            ret.userid = value(forKey: .userid)
            ret.banned = value(forKey: .banned)
            
            return ret
        }

        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()
            
            addRequired(key: .banned, value: banned)
            
            return toDictionary
        }
    }
    
    /// Searches the users in an app
    ///
    /// Use this method to cursor through a list of users. This method will return users in the order in which they were created, so it is safe to add new users while cursoring through the list.
    ///
    /// **Parameters**
    ///
    /// - cursor: (optional) Each call to ListUsers will return a result set with a 'nextCursor' value. To get the next page of users, pass this value as the optional 'cursor' property. To get the first page of users, omit the 'cursor' argument.
    ///
    /// - limit: (optional) You can omit this optional argument, in which case the default limit is 200 users to return.
    ///
    /// - name: (optional) Provide part of a name to search the user name field
    ///
    /// - handle: (optional) Provide part of a handle to search by handle
    ///
    /// - userid: (optional) Provide part of a userid to search by userid
    ///
    /// **Note**
    /// At least one of these parameters is required;
    /// - userid
    /// - handle
    /// - name
    ///
    /// **Warning** This method requires authentication
    ///
    public class SearchUser: ParametersBase<SearchUser.Fields, SearchUser> {
        public enum Fields {
            case cursor
            case limit
            case name
            case handle
            case userid
        }

        public var cursor:String?
        public var limit:Int?
        public var name:String?
        public var handle:String?
        public var userid:String?

        override public func from(dictionary: [AnyHashable: Any]) -> SearchUser {
            set(dictionary: dictionary)
            let ret = SearchUser()

            ret.cursor = value(forKey: .cursor)
            ret.limit = value(forKey: .limit)
            ret.name = value(forKey: .name)
            ret.userid = value(forKey: .userid)
            ret.handle = value(forKey: .handle)

            return ret
        }

        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()

            add(key: .cursor, value: cursor)
            add(key: .limit, value: limit)
            add(key: .name, value: name)
            add(key: .userid, value: userid)
            add(key: .handle, value: handle)
            
            return toDictionary
        }
    }
    
    /// Will toggle the user's mute effect
    ///
    /// A muted user is in a read-only state. The muted user can join chat rooms and observe but cannot communicate. This method applies mute on the global level (applies to all talk contexts). You can optionally specify an expiration time. If the expiration time is specified, then each time the shadow banned user tries to send a message the API will check if the shadow ban has expired and will lift the ban.
    ///
    /// **Paramters**
    ///
    /// - userid: (required) The applicaiton provided userid of the user to ban
    ///
    /// - applyeffect: (required) true or false. If true, user will be set to muted state. If false, will be set to non-banned state.
    ///
    /// - expireseconds: (optional) Duration of mute in seconds. If specified, the mute will be lifted when this time is reached. If not specified, mute effect remains until explicitly lifted. Maximum seconds is a double byte value.
    ///
    public class MuteUser: ParametersBase<MuteUser.Fields, MuteUser> {
        public enum Fields {
            case userid
            case applyeffect
            case expireseconds
        }
        
        public var userid: String?
        public var applyeffect: Bool?
        public var expireseconds: Double?
        
        override public func from(dictionary: [AnyHashable: Any]) -> MuteUser {
            set(dictionary: dictionary)
            let ret = MuteUser()
            
            ret.userid = value(forKey: .userid)
            ret.applyeffect = value(forKey: .applyeffect)
            ret.expireseconds = value(forKey: .applyeffect)
            
            return ret
        }
        
        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()
            
            addRequired(key: .userid, value: userid)
            addRequired(key: .applyeffect, value: applyeffect)
            add(key: .expireseconds, value: expireseconds)
            
            return toDictionary
        }
    }
    
    /// Reports a user to the moderation team.
    ///
    /// **Paramters**
    ///
    /// - userid: (required) This is the application specific user ID of the user reporting the first user.
    ///
    /// - reporttype: (required) Possible values: "abuse", "spam". SPAM is unsolicited commercial messages and abuse is hate speach or other unacceptable behavior.
    ///
    /// **RESPONSE CODES**
    ///
    /// - 200 | Success : Request completed successfully
    ///
    /// - 404 | Not Found : The specified user or application could not be found
    ///
    /// - 409 | Conflict : The request was rejected because user reporting is not enabled for the application
    ///
    public class ReportUser: ParametersBase<ReportUser.Fields, ReportUser> {
        public enum Fields {
            case userid
            case reporttype
        }
        
        public var userid: String?
        public var reporttype: ReportType? = .abuse
        
        override public func from(dictionary: [AnyHashable: Any]) -> ReportUser {
            set(dictionary: dictionary)
            let ret = ReportUser()
            
            ret.userid = value(forKey: .userid)
            ret.reporttype = value(forKey: .reporttype)
            
            return ret
        }
        
        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()
            
            addRequired(key: .userid, value: userid)
            add(key: .reporttype, value: reporttype?.rawValue)
            
            return toDictionary
        }
    }
    
    /// Will toggle the user's shadow banned flag
    ///
    /// A Shadow Ban user can send messages into a chat room, however those messages are flagged as shadow banned. This enables the application to show those messags only to the shadow banned user, so that that person may not know they were shadow banned. This method shadow bans the user on the global level (or you can use this method to lift the ban). You can optionally specify an expiration time. If the expiration time is specified, then each time the shadow banned user tries to send a message the API will check if the shadow ban has expired and will lift the ban.
    ///
    /// **Parameters**
    ///
    /// - userid: (required) The applicaiton provided userid of the user to ban
    ///
    /// - applyeffect: (required) true or false. If true, user will be set to banned state. If false, will be set to non-banned state.
    ///
    /// - expireseconds: (optional) Duration of shadowban value in seconds. If specified, the shadow ban will be lifted when this time is reached. If not specified, shadowban remains until explicitly lifted. Maximum seconds is a double byte value.
    ///
    public class SetShadowBanStatus: ParametersBase<SetShadowBanStatus.Fields, SetShadowBanStatus> {
        public enum Fields {
            case userid
            case applyeffect
            case expireseconds
        }
        
        public var userid: String?
        public var applyeffect: Bool?
        public var expireseconds: Int?
        
        override public func from(dictionary: [AnyHashable: Any]) -> SetShadowBanStatus {
            set(dictionary: dictionary)
            let ret = SetShadowBanStatus()
            
            ret.userid = value(forKey: .userid)
            ret.applyeffect = value(forKey: .applyeffect)
            ret.expireseconds = value(forKey: .expireseconds)
            
            return ret
        }
        
        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()
            
            addRequired(key: .applyeffect, value: applyeffect)
            add(key: .expireseconds, value: expireseconds)
            
            return toDictionary
        }
    }
    
    /// Returns a list of user notifications
    ///
    /// **Parameters**
    /// 
    /// - userid: (required) Return only notifications for this user
    ///
    /// - filternotificationtypes: (optional) Return only events of the specified type. Pass the argument more than once to fetch multiple types of notifications at once.
    ///
    ///     - chatmention
    ///     - chatquote
    ///     - chatreply
    ///     - commentmention
    ///     - commentquote
    ///     - commentreply
    ///
    /// - includeread: (optional | default = false) If true, notifications that have already been read are returned
    ///
    /// - filterchatroomid: (optional) If provided, this will only return notifications associated with the specified chat room using the ChatRoom ID (exact match)
    ///
    /// - filterchatroomcustomid: (optional) If provided, this will only return notifications associated with the specified chat room using the Custom ID (exact match)
    ///
    /// - limit: (optional) Default is 50, maximum is 200. Limits how many items are returned.
    ///
    /// - cursor: (optional) Leave blank to start from the beginning of the result set; provide the value from the previous returned cursor to resume cursoring through the next page of results
    ///
    public class ListUserNotifications: ParametersBase<ListUserNotifications.Fields, ListUserNotifications> {
        public enum Fields {
            case userid
            case filternotificationtypes
            case includeread
            case filterchatroomid
            case filterchatroomcustomid
            case limit
            case cursor
        }
        
        public var userid: String?
        public var filternotificationtypes: String?
        public var includeread: Bool? = false
        public var filterchatroomid: String?
        public var filterchatroomcustomid: String?
        public var limit: Int? = 50
        public var cursor: String? = ""
        
        override public func from(dictionary: [AnyHashable: Any]) -> ListUserNotifications {
            set(dictionary: dictionary)
            let ret = ListUserNotifications()
            
            ret.userid = value(forKey: .userid)
            ret.filternotificationtypes = value(forKey: .filternotificationtypes)
            ret.includeread = value(forKey: .includeread)
            ret.filterchatroomid = value(forKey: .filterchatroomid)
            ret.filterchatroomcustomid = value(forKey: .filterchatroomcustomid)
            ret.limit = value(forKey: .limit)
            ret.cursor = value(forKey: .cursor)

            return ret
        }
        
        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()
            
            add(key: .filternotificationtypes, value: filternotificationtypes)
            add(key: .includeread, value: includeread)
            add(key: .filterchatroomid, value: filterchatroomid)
            add(key: .filterchatroomcustomid, value: filterchatroomcustomid)
            add(key: .limit, value: limit)
            add(key: .cursor, value: cursor)
            
            return toDictionary
        }
    }
    
    /// Mark All User Notifications as Read
    ///
    /// This marks all of the user's notifications as read with one API call only. Due to caching, a call to List User Notifications may still return items for a short time. Set delete = true to delete the notification instead of marking it read. This should be used for most use cases.
    ///
    /// **Parameters**
    ///
    /// - userid: (required) The ID of the user marking the notification as read.
    ///
    /// - delete: (optional) [default=true] If true, this deletes the notification. If false, it marks it read but does not delete it.
    ///
    public class MarkAllNotificationAsRead: ParametersBase<MarkAllNotificationAsRead.Fields, MarkAllNotificationAsRead> {
        public enum Fields {
            case userid
            case delete
        }
        
        public var userid: String?
        public var delete: Bool? = true
        
        override public func from(dictionary: [AnyHashable: Any]) -> MarkAllNotificationAsRead {
            set(dictionary: dictionary)
            let ret = MarkAllNotificationAsRead()
            
            ret.userid = value(forKey: .userid)
            ret.delete = value(forKey: .delete)
            
            return ret
        }
        
        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()
            
            add(key: .delete, value: delete)
            
            return toDictionary
        }
    }
    
    /// Set User Notification as Read
    ///
    /// Unless your workflow must support use of read notifications, instead use ```func deleteUserNotification(_ request:completionHandler:)```
    ///
    /// This marks a notification as being in READ status. That will prevent the notification from being returned in a call to List User Notifications unless the default filters are overridden. Notifications that are marked as read will be automatically deleted after some time.
    ///
    /// Calling this over and over again for an event, or calling it on events where the reader is not the person that the reply is directed to, or calling it against events that are not type ChatReply or ChatQuote is inappropriate use of the API
    ///
    /// **Parameters**
    ///
    /// - userid: (required) The ID of the user marking the notification as read. This is used to ensure a user can't mark another user's notification as read.
    ///
    /// - notificationid: (required) The unique ID of the notification being updated
    ///
    /// - read: (required) The read status (true/false) for the notification. You can pass false to mark the notification as unread
    ///
    public class SetUserNotificationAsRead: ParametersBase<SetUserNotificationAsRead.Fields, SetUserNotificationAsRead> {
        public enum Fields {
            case userid
            case notificationid
            case read
        }
        
        public var userid: String?
        public var notificationid: String?
        public var read: Bool? = false
        
        override public func from(dictionary: [AnyHashable: Any]) -> SetUserNotificationAsRead {
            set(dictionary: dictionary)
            let ret = SetUserNotificationAsRead()
            
            ret.userid = value(forKey: .userid)
            ret.notificationid = value(forKey: .notificationid)
            ret.read = value(forKey: .read)
            
            return ret
        }
        
        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()
            
            add(key: .read, value: read)
            
            return toDictionary
        }
    }
    
    /// Set Notification Read Status (by ChatEventId)
    ///
    /// Unless your workflow must support use of read notifications, use
    /// 
    /// ```func deleteUserNotification(_ request:completionHandler:)``` instead.
    ///
    /// - This marks a notification as being in READ status.
    ///
    /// - That will prevent the notification from being returned in a call to List User Notifications unless the default filters are overridden.
    ///
    /// - Notifications that are marked as read will be automatically deleted after some time.
    ///
    /// - Only call this once per event. Only call this for events of type ChatReply or ChatQuote
    ///
    /// **Parameters**
    ///
    /// - userid: (required) The ID of the user marking the notification as read. This is used to ensure a user can't mark another user's notification as read.
    ///
    /// - chateventid: (required) The unique ID of the notification's chatEvent.
    ///
    /// - read: (required) The read status (true/false) for the notification. You can pass false to mark the notification as unread.
    ///
    public class SetUserNotificationAsReadByChatEventId: ParametersBase<SetUserNotificationAsReadByChatEventId.Fields, SetUserNotificationAsReadByChatEventId> {
        public enum Fields {
            case userid
            case chateventid
            case read
        }
        
        public var userid: String?
        public var eventid: String?
        public var read: Bool? = false
        
        override public func from(dictionary: [AnyHashable: Any]) -> SetUserNotificationAsReadByChatEventId {
            set(dictionary: dictionary)
            let ret = SetUserNotificationAsReadByChatEventId()
            
            ret.userid = value(forKey: .userid)
            ret.eventid = value(forKey: .chateventid)
            ret.read = value(forKey: .read)
            
            return ret
        }
        
        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()
            
            add(key: .read, value: read)
            
            return toDictionary
        }
    }
    
    /// Deletes a User Notification
    ///
    /// Immediately deletes a user notification. Unless your workflow specifically implements access to read notifications, you should delete notifications after they are consumed.
    ///
    /// **Parameters**
    ///
    /// - userid: (required) The ID of the user marking the notification as read. This is used to ensure a user can't mark another user's notification as read.
    ///
    /// - notificationid: (required) The unique ID of the notification being updated.
    ///
    public class DeleteUserNotification: ParametersBase<DeleteUserNotification.Fields, DeleteUserNotification> {
        public enum Fields {
            case userid
            case notificationid
        }
        
        public var userid: String?
        public var notificationid: String?
        
        override public func from(dictionary: [AnyHashable: Any]) -> DeleteUserNotification {
            set(dictionary: dictionary)
            let ret = DeleteUserNotification()
            
            ret.userid = value(forKey: .userid)
            ret.notificationid = value(forKey: .notificationid)
            
            return ret
        }
        
        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()
            return toDictionary
        }
    }
    
    /// Deletes a User Notification
    /// 
    /// Immediately deletes a user notification. Unless your workflow specifically implements access to read notifications, you should delete notifications after they are consumed.
    ///
    /// **Parameters**
    ///
    /// - userid: (required) The ID of the user marking the notification as read. This is used to ensure a user can't mark another user's notification as read.
    ///
    /// - chateventid: (required) The unique ID of the notification's chatEvent.
    ///
    public class DeleteUserNotificationByChatEventId: ParametersBase<DeleteUserNotificationByChatEventId.Fields, DeleteUserNotificationByChatEventId> {
        public enum Fields {
            case userid
            case chateventid
        }
        
        public var userid: String?
        public var eventid: String?
        
        override public func from(dictionary: [AnyHashable: Any]) -> DeleteUserNotificationByChatEventId {
            set(dictionary: dictionary)
            let ret = DeleteUserNotificationByChatEventId()
            
            ret.userid = value(forKey: .userid)
            ret.eventid = value(forKey: .chateventid)
            
            return ret
        }
        
        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()
            return toDictionary
        }
    }
}
