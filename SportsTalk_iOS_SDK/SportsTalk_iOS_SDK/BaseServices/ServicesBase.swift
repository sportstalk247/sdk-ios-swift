import Foundation
import CommonCrypto

public typealias CompletionHandler = (_ success:[AnyHashable: Any]) -> Void

enum RequestType: String {
    case GET
    case POST
    case PUT
    case DELETE
}

open class ServicesBase
{
    public var authToken: String?
    public var url: URL?
    public var services: Services?

    func makeRequest(_ serviceName: String?, withData data: [AnyHashable: Any]?, requestType: RequestType, appendData:Bool = true, completionHandler: @escaping CompletionHandler)
    {
        if let requiredParameterIsNilError = checkRequiredParameters(data)
        {
            completionHandler(requiredParameterIsNilError)
        }
        
        // Create the request
        let request = makeURLRequest(serviceName, withData: data, requestType: requestType, appendData: appendData)
                
        URLSession.shared.dataTask(with: request, completionHandler: {data, response, error -> Void in
            if let error = error
            {
                // Deal with your error
                if (response is HTTPURLResponse)
                {
                    let httpResponse = response as? HTTPURLResponse
                    print(String(format: "\(httpError) %ld", Int(httpResponse?.statusCode ?? 0)))
                }
                
                print(error)
                completionHandler([messageTitle: "\(error.localizedDescription)"])
            }
            else
            {
                do
                {
                    if let data = data
                    {
                        if let jsonData = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
                        {
                            completionHandler(jsonData)
                        }
                    }
                }
                catch let error
                {
                    print("\(jsonParsingError) \(serviceName ?? emptyString): \(error.localizedDescription)")
                    completionHandler([messageTitle: "\(serviceName ?? emptyString): \(error.localizedDescription)"])
                }
            }
        }).resume()
    }

    func checkRequiredParameters(_ dataDictionary: [AnyHashable: Any]?) -> [AnyHashable: Any]?
    {
        if let dataDictionary = dataDictionary, let errorMessage = dataDictionary[errorMessageTitle]
        {
            return [messageTitle: errorMessage]
        }
        
        return nil
    }
    
    func makeURLRequest(_ serviceName: String?, withData data: [AnyHashable: Any]?, requestType: RequestType, appendData: Bool) -> URLRequest
    {
        var jsonData: Data? = nil

        do
        {
            jsonData = try JSONSerialization.data(withJSONObject: data as Any, options: [])
        }
        catch
        {}

        var json: String? = nil
        if let jsonData = jsonData
        {
            json = String(data: jsonData, encoding: .utf8)
        }

        let postData =  json?.data(using: .utf8)
        
        // Generate url.
        let url = URL(string: "\(self.url?.absoluteString ?? emptyString)/\(serviceName ?? emptyString)")!

        // Create the request
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = requestType.rawValue

        if (requestType == .POST && appendData) || requestType == .PUT
        {
            request.httpBody = postData
        }
        else if requestType == .GET && appendData
        {
            var components = URLComponents(string: url.absoluteString)!
            components.queryItems = [URLQueryItem]()
            
            for (key, value) in (data ?? [AnyHashable : Any]())
            {
                let item = URLQueryItem(name: "\(key)", value: "\(value)")
                components.queryItems?.append(item)
            }
            
            if let componentUrl = components.url
            {
                request.url = componentUrl
            }
        }

//        request.addValue(acceptHeaderValue, forHTTPHeaderField: acceptHeaderTitle)
//        request.addValue(contentTypeValue, forHTTPHeaderField: acceptHeaderValue)
        request.addValue(self.authToken ?? emptyString, forHTTPHeaderField: tokenTitle)

        return request
    }
}
