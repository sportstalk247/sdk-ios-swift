import Foundation

public protocol UserClientProtocol {
    func createOrUpdateUser(_ request: UserRequest.CreateUpdateUser, completionHandler: @escaping Completion<User>)
    func deleteUser(_ request: UserRequest.DeleteUser, completionHandler: @escaping Completion<DeleteUserResponse>)
    func getUserDetails(_ request: UserRequest.GetUserDetails, completionHandler: @escaping Completion<User>)
    func listUsers(_ request: UserRequest.ListUsers, completionHandler: @escaping Completion<ListUsersResponse>)
    func setBanStatus(_ request: UserRequest.setBanStatus, completionHandler: @escaping Completion<User>)
    func searchUser(_ request: UserRequest.SearchUser, completionHandler: @escaping Completion<ListUsersResponse>)
}

public class UserClient: NetworkService, UserClientProtocol {
    internal var lastTimeStamp: Int64 = 0
    
    public override init(config: ClientConfig) {
        super.init(config: config)
    }
}

extension UserClient {
    public func createOrUpdateUser(_ request: UserRequest.CreateUpdateUser, completionHandler: @escaping Completion<User>) {
        makeRequest(URLPath.User.CreateUpdate(userid: request.userid ?? ""), withData: request.toDictionary(), requestType: .POST, expectation: User.self) { response in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    public func deleteUser(_ request: UserRequest.DeleteUser, completionHandler: @escaping Completion<DeleteUserResponse>) {
        makeRequest(URLPath.User.Delete(userid: request.userid ?? ""), withData: request.toDictionary(), requestType: .DELETE, expectation: DeleteUserResponse.self) { response in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    public func getUserDetails(_ request: UserRequest.GetUserDetails, completionHandler: @escaping Completion<User>) {
        makeRequest(URLPath.User.GetDetails(userid: request.userid ?? ""), withData: request.toDictionary(), requestType: .GET, expectation: User.self) { response in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }

    public func listUsers(_ request: UserRequest.ListUsers, completionHandler: @escaping Completion<ListUsersResponse>) {
        makeRequest(URLPath.User.List(), withData: request.toDictionary(), requestType: .GET, expectation: ListUsersResponse.self) { response in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    public func setBanStatus(_ request: UserRequest.setBanStatus, completionHandler: @escaping Completion<User>) {
        makeRequest(URLPath.User.Ban(userid: request.userid ?? ""), withData: request.toDictionary(), requestType: .POST, expectation: User.self) { response in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
    
    public func searchUser(_ request: UserRequest.SearchUser, completionHandler: @escaping Completion<ListUsersResponse>) {
        makeRequest(URLPath.User.Search(), withData: request.toDictionary(), requestType: .POST, expectation: ListUsersResponse.self) { (response) in
            completionHandler(response?.code, response?.message, response?.kind, response?.data)
        }
    }
}