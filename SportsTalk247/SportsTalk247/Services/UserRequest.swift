import Foundation

public class UserRequest {
    
    /// Invoke this API method if you want to create a user or update an existing user.
    ///
    /// When users send messages to a room the user ID is passed as a parameter. When you retrieve the events from a room, the user who generated the event is returned with the event data, so it is easy for your application to process and render chat events with minimal code.
    ///
    /// userid: Required. If the userid is new then the user will be created. If the userid is already in use in the database then the user will be updated.
    ///
    /// handle: (Optional) If you are creating a user and you don't specify a handle, the system will generate one for you (using Display Name as basis if you provide that). If you request a handle and it's already in use a new handle will be generated for you and returned. Handle is an easy to type unique identifier for a user, for example @GeorgeWashington could be the handle but Display Name could be "da prez numero uno".
    ///
    /// displayname: Optional. This is the desired name to display, typically the real name of the person.
    ///
    /// pictureurl: Optional. The URL to the picture for this user.
    ///
    /// profileurl: Optional. The profileurl for this user.
    ///
    /// - Warning: Do not use this method to convert an anonymous user into a known user. Use the Convert User api method instead.
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
    /// UserId is the app specific User ID provided by your application.
    ///
    /// - Warning: This method requires authentication
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
    
    /// Get the details about a User
    ///
    /// This will return all the information about the user.
    ///
    /// UserId is the app specific User ID provided by your application.
    ///
    /// - Warning: This method requires authentication
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
    
    /// Use this method to cursor through a list of users. This method will return users in the order in which they were created, so it is safe to add new users while cursoring through the list.
    ///
    /// cursor: Each call to ListUsers will return a result set with a 'nextCursor' value. To get the next page of users, pass this value as the optional 'cursor' property. To get the first page of users, omit the 'cursor' argument.
    ///
    /// limit: You can omit this optional argument, in which case the default limit is 200 users to return.
    ///
    /// - Warning: This method requires authentication.
    public class ListUsers: ParametersBase<ListUsers.Fields, ListUsers> {
        public enum Fields {
            case cursor
            case limit
        }

        public var cursor: String?
        public var limit: String? = defaultLimit

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
    
    /// Use this method ban/restore a user.
    ///
    /// userid: (required) The applicaiton provided userid of the user to ban
    /// banned: (required) set true to ban a user; set false to restore a user
    ///
    /// - Warning: This method requires authentication.
    public class SetBanStatus: ParametersBase<SetBanStatus.Fields, SetBanStatus> {
        public enum Fields {
            case userid
            case banned
        }

        public var userid: String?
        public var banned: Bool?
        
        override public func from(dictionary: [AnyHashable: Any]) -> SetBanStatus {
            set(dictionary: dictionary)
            let ret = SetBanStatus()

            ret.userid = value(forKey: .userid)
            ret.banned = value(forKey: .banned)
         
            return ret
        }

        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()

            add(key: .banned, value: banned)
            
            return toDictionary
        }
    }
    
    /// Will purge all chat content published by the specified user
    ///
    /// userid: (required) The application provided userid of the user to ban
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
    /// userid: Required. If the userid is new then the user will be created. If the userid is already in use in the database then the user will be updated.
    ///
    /// Arguments:
    ///
    /// cursor: Each call to ListUsers will return a result set with a 'nextCursor' value. To get the next page of users, pass this value as the optional 'cursor' property. To get the first page of users, omit the 'cursor' argument.
    ///
    /// limit: You can omit this optional argument, in which case the default limit is 200 users to return.
    ///
    /// name: Provide part of a name to search the user name field
    ///
    /// handle: Provide part of a handle to search by handle
    ///
    /// userid: Provide part of a userid to search by userid
    ///
    /// - Warning: This method requires authentication.
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
    
    /// REPORTS a USER to the moderation team.
    ///
    ///
    /// Arguments:
    ///
    /// userid : (required) This is the application specific user ID of the user reporting the first user.
    ///
    /// reporttype : (required) Possible values: "abuse", "spam". SPAM is unsolicited commercial messages and abuse is hate speach or other unacceptable behavior.
    ///
    /// Response:
    ///
    /// Code    Meaning     Description
    /// 200     OK          Request completed successfully
    /// 404     Not Found   The specified user or application could not be found
    /// 409     Conflict    The request was rejected because user reporting is not enabled for the application
    ///
    public class ReportUser: ParametersBase<ReportUser.Fields, ReportUser> {
        public enum Fields {
            case userid
            case reporttype
        }
        
        public var userid: String?
        public var reporttype = "abuse"
        
        override public func from(dictionary: [AnyHashable: Any]) -> ReportUser {
            set(dictionary: dictionary)
            let ret = ReportUser()
            
            ret.userid = value(forKey: .userid)
            ret.reporttype = value(forKey: .reporttype) ?? "abuse"
            
            return ret
        }
        
        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()
            
            addRequired(key: .userid, value: userid)
            add(key: .reporttype, value: reporttype)
            
            return toDictionary
        }
    }
    
    /// Will toggle the user's shadow banned flag
    ///
    /// Arguements
    ///
    /// userid: (required) The applicaiton provided userid of the user to ban
    ///
    /// shadowban: (required) true or false. If true, user will be set to banned state. If false, will be set to non-banned state.
    ///
    /// expireseconds: (optional) Duration of shadowban value in seconds. If specified, the shadow ban will be lifted when this time is reached. If not specified, shadowban remains until explicitly lifted. Maximum seconds is a double byte value.
    ///
    public class SetShadowBanStatus: ParametersBase<SetShadowBanStatus.Fields, SetShadowBanStatus> {
        public enum Fields {
            case userid
            case shadowban
            case expireseconds
        }
        
        public var userid: String?
        public var shadowban: Bool?
        public var expireseconds: Int?
        
        override public func from(dictionary: [AnyHashable: Any]) -> SetShadowBanStatus {
            set(dictionary: dictionary)
            let ret = SetShadowBanStatus()
            
            ret.userid = value(forKey: .userid)
            ret.shadowban = value(forKey: .shadowban)
            ret.expireseconds = value(forKey: .expireseconds)
            
            return ret
        }
        
        public func toDictionary() -> [AnyHashable: Any] {
            toDictionary = [AnyHashable: Any]()
            
            addRequired(key: .shadowban, value: shadowban)
            add(key: .expireseconds, value: expireseconds)
            
            return toDictionary
        }
    }
}
