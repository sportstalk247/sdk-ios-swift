import Foundation

public protocol UserClientProtocol {
    func createOrUpdateUser(_ request: UsersServices.CreateUpdateUser, completionHandler: @escaping Completion<User>)
    func deleteUser(_ request: UsersServices.DeleteUser, completionHandler: @escaping Completion<DeleteUserResponse>)
    func getUserDetails(_ request: UsersServices.GetUserDetails, completionHandler: @escaping Completion<User>)
    func listUsers(_ request: UsersServices.ListUsers, completionHandler: @escaping Completion<ListUsersResponse>)
    func setBanStatus(_ request: UsersServices.setBanStatus, completionHandler: @escaping Completion<User>)
    func searchUser(_ request: UsersServices.SearchUser, completionHandler: @escaping Completion<ListUsersResponse>)
    
    /* Deprecated */
    func banUser(_ request: UsersServices.BanUser, completionHandler: @escaping Completion<User>)
    func restoreUser(_ request: UsersServices.RestoreUser, completionHandler: @escaping Completion<User>)
    func searchByHandle(_ request: UsersServices.SearchUsersByHandle, completionHandler: @escaping Completion<ListUsersResponse>)
    func searchByName(_ request: UsersServices.SearchUsersByName, completionHandler: @escaping Completion<ListUsersResponse>)
    func searchByUserId(_ request: UsersServices.SearchUsersByUserId, completionHandler: @escaping Completion<ListUsersResponse>)
}

public class UserClient: NetworkService, UserClientProtocol {
    internal var lastTimeStamp: Int64 = 0
    
    public override init(config: ClientConfig) {
        super.init(config: config)
    }
}

extension UserClient {
    public func createOrUpdateUser(_ request: UsersServices.CreateUpdateUser, completionHandler: @escaping Completion<User>) {
        makeRequest("\(ServiceKeys.user)\(request.userid ?? emptyString)", withData: request.toDictionary(), requestType: .POST, expectation: User.self) { response in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    public func deleteUser(_ request: UsersServices.DeleteUser, completionHandler: @escaping Completion<DeleteUserResponse>) {
        makeRequest("\(ServiceKeys.user)\(request.userid ?? emptyString)", withData: request.toDictionary(), requestType: .DELETE, expectation: DeleteUserResponse.self) { response in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    public func getUserDetails(_ request: UsersServices.GetUserDetails, completionHandler: @escaping Completion<User>) {
        makeRequest("\(ServiceKeys.user)\(request.userid ?? emptyString)", withData: request.toDictionary(), requestType: .GET, expectation: User.self) { response in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }

    public func listUsers(_ request: UsersServices.ListUsers, completionHandler: @escaping Completion<ListUsersResponse>) {
        makeRequest(ServiceKeys.user, withData: request.toDictionary(), requestType: .GET, expectation: ListUsersResponse.self) { response in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    public func setBanStatus(_ request: UsersServices.setBanStatus, completionHandler: @escaping Completion<User>) {
        makeRequest("\(ServiceKeys.user)\(request.userid ?? emptyString)/ban", withData: request.toDictionary(), requestType: .POST, expectation: User.self) { response in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    public func searchUser(_ request: UsersServices.SearchUser, completionHandler: @escaping Completion<ListUsersResponse>) {
        makeRequest("user/search", withData: request.toDictionary(), requestType: .POST, expectation: ListUsersResponse.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
}

// MARK: - Deprecated
extension UserClient {
    @available(swift, deprecated: 5, renamed: "setBanStatus", message: "Use setBanStatus with request.banned = true")
    public func banUser(_ request: UsersServices.BanUser, completionHandler: @escaping Completion<User>) {
        makeRequest("\(ServiceKeys.user)\(request.userid ?? emptyString)/ban", withData: request.toDictionary(), requestType: .POST, expectation: User.self) { response in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }

    @available(swift, deprecated: 5, renamed: "setBanStatus", message: "Use setBanStatus with request.banned = false")
    public func restoreUser(_ request: UsersServices.RestoreUser, completionHandler: @escaping Completion<User>) {
        makeRequest("\(ServiceKeys.user)\(request.userid ?? emptyString)/ban", withData: request.toDictionary(), requestType: .POST, expectation: User.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    @available(swift, deprecated: 5, renamed: "SearchUser", message: "Use SearchUser with request.handle = \"user_handle\"")
    public func searchByHandle(_ request: UsersServices.SearchUsersByHandle, completionHandler: @escaping Completion<ListUsersResponse>) {
        makeRequest("user/search", withData: request.toDictionary(), requestType: .POST, expectation: ListUsersResponse.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }

    @available(swift, deprecated: 5, renamed: "SearchUser", message: "Use SearchUser with request.name = \"user_name\"")
    public func searchByName(_ request: UsersServices.SearchUsersByName, completionHandler: @escaping Completion<ListUsersResponse>) {
        makeRequest("user/search", withData: request.toDictionary(), requestType: .POST, expectation: ListUsersResponse.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }

    @available(swift, deprecated: 5, renamed: "SearchUser", message: "Use SearchUser with request.userid = \"user_userid\"")
    public func searchByUserId(_ request: UsersServices.SearchUsersByUserId, completionHandler: @escaping Completion<ListUsersResponse>) {
        makeRequest("user/search", withData: request.toDictionary(), requestType: .POST, expectation: ListUsersResponse.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
}
