import Foundation

open class Services
{
    let baseUrl = URL(string: "http://api-origin.sportstalk247.com/api/v3") // http://api-origin.sportstalk247.com/api/v3
    
    private var _authToken: String?
    private lazy var _url: URL? = baseUrl
    private var _ams = ServicesAMS()
    
    internal var knownRooms: Any?
    internal var _updatesApi: String?
    internal var _roomApi: String?
    internal var _commandApi: String?
    internal lazy var _endpoint = _url
    internal var _currentRoom: [AnyHashable: Any]?

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
            self.services = self
        }
    }
    
    open var services: Services?

    public init() { }
}
