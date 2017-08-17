import Foundation

open class SHResponse {
    
    public var JSON: Any? {
        
        get {
            switch _JSON {
            case _ as [Any]:
                return _JSON as! [Any]
            case _ as [String : Any]:
                return _JSON as! [String : Any]
            default:
                return _JSON
            }
        }
    }
    
    public var statusCode: Int? {
        
        get {
            return (response as? HTTPURLResponse)?.statusCode
        }
    }
    
    fileprivate var _JSON: Any?
    
    fileprivate let response: URLResponse?
    
    init(data: Data? = nil, response: URLResponse?, parseKeys: [String]? = nil) {
        
        self.response = response
        dataToJSON(data, parseKeys: parseKeys)
    }
    
    internal func dataToJSON(_ incomingData: Data?, parseKeys: [String]?) {
        
        guard
            let data = incomingData,
            let json = SHJSON.createJSONObjectFrom(data)
            else {
            //TODO: Add to Errors
            return
        }
        
        _JSON = json as AnyObject?
        
        guard let pKeys = parseKeys else {
            return
        }
        
        for key in pKeys {
            
            if let JSONPart = (_JSON as AnyObject)[key] {
                
                _JSON = JSONPart
                
            } else {
                
                NSLog("error: Parsing JSON Error")//TODO: Add to Errors
            }
        }
    }
}