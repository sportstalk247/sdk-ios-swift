import Foundation

public protocol ServicesAMSProtocol
{
    var authToken: String?
    {
        get set
    }
    
    var url: URL?
    {
        get set
    }

    func usersServices(_ request: UsersServices.CreateUpdateUser, completionHandler: @escaping CompletionHandler)
    func usersServices(_ request: UsersServices.GetUserDetails, completionHandler: @escaping CompletionHandler)
    func usersServices(_ request: UsersServices.ListUsers, completionHandler: @escaping CompletionHandler)
    func usersServices(_ request: UsersServices.ListUsersMore, completionHandler: @escaping CompletionHandler)
    func usersServices(_ request: UsersServices.ListMessagesByUser, completionHandler: @escaping CompletionHandler)
    func usersServices(_ request: UsersServices.SearchUsersByHandle, completionHandler: @escaping CompletionHandler)
    func usersServices(_ request: UsersServices.SearchUsersByName, completionHandler: @escaping CompletionHandler)
    func usersServices(_ request: UsersServices.SearchUsersByUserId, completionHandler: @escaping CompletionHandler)
}

open class ServicesAMS: ServicesBase, ServicesAMSProtocol
{
    public func usersServices(_ request: UsersServices.CreateUpdateUser, completionHandler: @escaping CompletionHandler)
    {
        makeRequest("user/\(request.userid ?? emptyString)", withData: request.toDictionary(), requestType: .POST) { (response) in
            completionHandler(response)
        }
    }
    
    public func usersServices(_ request: UsersServices.GetUserDetails, completionHandler: @escaping CompletionHandler)
    {
        makeRequest("user/\(request.userid ?? emptyString)", withData: request.toDictionary(), requestType: .GET, appendData: false) { (response) in
            completionHandler(response)
        }
    }

    public func usersServices(_ request: UsersServices.ListUsers, completionHandler: @escaping CompletionHandler)
    {
        makeRequest("user", withData: request.toDictionary(), requestType: .GET) { (response) in
            completionHandler(response)
        }
    }

    public func usersServices(_ request: UsersServices.ListUsersMore, completionHandler: @escaping CompletionHandler)
    {
        makeRequest("user", withData: request.toDictionary(), requestType: .GET) { (response) in
            completionHandler(response)
        }
    }

    public func usersServices(_ request: UsersServices.ListMessagesByUser, completionHandler: @escaping CompletionHandler)
    {
        makeRequest("user/\(request.userId ?? emptyString)", withData: request.toDictionary(), requestType: .GET) { (response) in
            completionHandler(response)
        }
    }

    public func usersServices(_ request: UsersServices.SearchUsersByHandle, completionHandler: @escaping CompletionHandler)
    {
        makeRequest("user/search", withData: request.toDictionary(), requestType: .POST) { (response) in
            completionHandler(response)
        }
    }

    public func usersServices(_ request: UsersServices.SearchUsersByName, completionHandler: @escaping CompletionHandler)
    {
        makeRequest("user/search", withData: request.toDictionary(), requestType: .POST) { (response) in
            completionHandler(response)
        }
    }

    public func usersServices(_ request: UsersServices.SearchUsersByUserId, completionHandler: @escaping CompletionHandler)
    {
        makeRequest("user/search", withData: request.toDictionary(), requestType: .POST) { (response) in
            completionHandler(response)
        }
    }

}


