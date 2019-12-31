import UIKit

enum Error {
    case messsage
}

open class ParametersBase<T,S>
{
    var dictionary = [AnyHashable: Any]()
    var toDictionary = [AnyHashable: Any]()
    
    public init() {}
    
    func from(dictionary: [AnyHashable: Any]) -> S
    {
        preconditionFailure("Override function in child class otherwise it will give error")
    }
    
    func add(key: T, value: Any?)
    {
        toDictionary[toString(key: key)] = value
    }
    
    func addRequired(key: T, value: String?)
    {
        if let value = value, value != emptyString {
            toDictionary[toString(key: key)] = value
        }
        else
        {
            toDictionary[errorMessageTitle] = returnError(parameterString: toString(key: key))
        }
    }

    func set(dictionary: [AnyHashable: Any])
    {
        self.dictionary = dictionary
    }

    func value(forKey key: T) -> Int?
    {
        return (dictionary[toString(key: key)] as? NSNumber)?.intValue
    }
    
    func value(forKey key: T) -> Int
    {
        return (dictionary[toString(key: key)] as? NSNumber)?.intValue ?? 0
    }

    func value(forKey key: T) -> String?
    {
        return (dictionary[toString(key: key)] as? String)
    }
    
    func value(forKey key: T) -> URL?
    {
        guard let urlString = (dictionary[toString(key: key)] as? String) else { return nil }
        
        return URL(string: urlString)
    }
 
    func toString(key: T) -> String
    {
        return "\(key)"
    }
    
    func returnError(parameterString:String) -> String {
        return "\(errorMessageString) \(parameterString)"
    }
}
