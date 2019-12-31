import Foundation

open class Services
{
    let baseUrl = URL(string: "http://api-origin.sportstalk247.com/api/v3")
    
    private var _authToken: String?
    private var _url: URL?
    private var _ams = ServicesAMS()

    open var ams: ServicesAMS
    {
        get
        {
            return _ams
        }
        set
        {
            _ams = newValue
        }
    }

    open var authToken: String?
    {
        get
        {
            return _authToken
        }
        set
        {
            _authToken = newValue
            self.ams.authToken = newValue
        }
    }

    open var url: URL?
    {
        get
        {
            return _url
        }
        set
        {
            _url = newValue
            self.ams.url = newValue
        }
    }

    public init()
    {
        url = baseUrl
    }

    init(_ url: URL?)
    {
        let ret = Services()

        ret.url = url
    }

    init(_ url: URL?, andAuthToken authToken: String)
    {
        let ret = Services(url)

        ret.authToken = authToken
    }
    
    init(authToken: String)
    {
        let ret = Services()
        
        ret.authToken = authToken
    }
}
