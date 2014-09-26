//
//  HTTP.swift
//  Thrust
//
//  Created by Patrick Perini on 8/13/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation

// MARK: - Extensions
extension Dictionary {
    /// Returns a representation of the dictionary using percent escapes necessary to convert the key-value pairs into a legal URL string.
    var urlSerializedString: String {
        get {
            var serializedString: String = ""
            for (key, value) in self {
                let encodedKey = "\(key)".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
                let encodedValue = "\(value)".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
                
                if !serializedString.hasContent {
                    serializedString = "\(encodedKey)=\(encodedValue)"
                } else {
                    serializedString += "&\(encodedKey)=\(encodedValue)"
                }
            }
            
            return serializedString
        }
    }
}

class HTTP {
    // MARK: - Responses
    struct Response: DebugPrintable {
        // MARK: - Properties
        // MARK: Request Information
        /// The original request URL, with query parameters.
        var requestURL: NSURL
        /// The original request body.
        var requestBody: NSData
        
        // MARK: Response Information
        /// The response's HTTP status code.
        var status: Int?
        /// The response's binary data.
        var data: NSData?
        
        /// The response's data as a UTF8-string.
        var string: String? {
            return NSString(data: self.data!, encoding: NSUTF8StringEncoding) as String
        }
        
        /// The responses's data as a JSON container.
        var object: JSONContainer? {
            return self.string?.jsonObject
        }
        
        var debugDescription: String {
            return "\(self.requestURL) - \(self.status ?? 0)\n\t\(self.string ?? String())"
        }
    }
    
    // MARK: - Requests
    private struct Request {
        // MARK: Required Properties
        var url: NSURL
        var method: Method
        
        // MARK: Optional Properties
        var headers: [String: String]?
        var params: [String: String]?
        var payload: JSONContainer?
        var block: ((Response) -> Void)?
        
        // MARK: Request Operations
        func asyncRequest() {
            on (Queue.background) {
                let response: Response = self.syncRequest()
                on (Queue.main) {
                    self.block?(response)
                }
            }
        }
        
        func syncRequest() -> Response {
            // Setup variables
            var urlString: String = self.url.absoluteString!
            let requestBody: NSData = self.payload?.jsonString?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true) ?? NSData()
            
            // Add parameters
            if params != nil {
                urlString += "?\(params!.urlSerializedString)"
            }
            
            // Build request
            let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString))
            urlRequest.HTTPMethod = method.toRaw()
            urlRequest.HTTPBody = requestBody
            
            // ... add headers
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            if headers != nil {
                for (key, value) in headers! {
                    urlRequest.setValue(value, forHTTPHeaderField: key)
                }
            }
            
            // Build response
            var urlResponse: NSURLResponse?
            let responseBody: NSData? = NSURLConnection.sendSynchronousRequest(urlRequest,
                returningResponse: &urlResponse,
                error: nil)
            
            var response: Response = Response(requestURL: NSURL(string: urlString), requestBody: requestBody, status: nil, data: nil)
            if let httpURLResponse = urlResponse as? NSHTTPURLResponse {
                response.data = responseBody
                response.status = httpURLResponse.statusCode
            }
            
            return response
        }
    }
    
    struct RequestBatch {
        // MARK: Properties
        private var requests: [Request] = []
        var requestCount: Int {
            return self.requests.count
        }
        
        // MARK: Mutators
        mutating func addGETRequest(url: NSURL, headers: [String: String]? = nil, params: [String: String]? = nil) {
            self.addRequest(url,
                method: Method.GET,
                headers: headers,
                params: params,
                payload: nil)
        }
        
        mutating func addPUTRequest(url: NSURL, headers: [String: String]? = nil, params: [String: String]? = nil, payload: JSONContainer?) {
            self.addRequest(url,
                method: Method.PUT,
                headers: headers,
                params: params,
                payload: payload)
        }
        
        mutating func addPOSTRequest(url: NSURL, headers: [String: String]? = nil, params: [String: String]? = nil, payload: JSONContainer?) {
            self.addRequest(url,
                method: Method.POST,
                headers: headers,
                params: params,
                payload: payload)
        }
        
        mutating func addDELETERequest(url: NSURL, headers: [String: String]? = nil, params: [String: String]? = nil) {
            self.addRequest(url,
                method: Method.DELETE,
                headers: headers,
                params: params,
                payload: nil)
        }

        private mutating func addRequest(url: NSURL, method: Method, headers: [String: String]? = nil, params: [String: String]? = nil, payload: JSONContainer?) {
            let request: Request = Request(url: url,
                method: method,
                headers: headers,
                params: params,
                payload: payload,
                block: nil)
            
            var requests: [Request] = self.requests
            requests.append(request)
            self.requests = requests
        }
        
        // MARK: Performers
        mutating func performRequests(block: ([Response]) -> Void) {
            let requestQueue: Queue = Queue(label: "Thrust.Swift.RequestBatch.performRequests")
            on (requestQueue) {
                var responses: [Response] = []
                for request: Request in self.requests {
                    let response: Response = request.syncRequest()
                    responses.append(response)
                }
                
                self.requests = []
                on (Queue.main) {
                    block(responses)
                }
            }
        }
    }
    
    // MARK: - Methods
    private enum Method: String {
        case GET = "GET"
        case PUT = "PUT"
        case POST = "POST"
        case DELETE = "DELETE"
    }
    
    // MARK: - Requests
    /**
    
    Executes an HTTP GET request on the given URL.
    
    :param: url The URL to request.
    :param: headers HTTP headers.
    :param: params URL parameters, which become the request's query string.
    :param: block A reponse handler that takes a single HTTP.Response argument.
    
    */
    class func get(url: NSURL, headers: [String: String]? = nil, params: [String: String]? = nil, block: ((Response) -> Void)?) {
        let request: Request = Request(url: url,
            method: Method.GET,
            headers: headers,
            params: params,
            payload: nil,
            block: block)
        request.asyncRequest()
    }
    
    /**
    
    Executes an HTTP GET request on the given URL.
    
    :param: url The URL to request.
    :param: headers HTTP headers.
    :param: params URL parameters, which become the request's query string.
    
    :returns: The HTTP.Response object representing the request's response.
    
    */
    class func get(url: NSURL, headers: [String: String]? = nil, params: [String: String]? = nil) -> Response {
        let request: Request = Request(url: url,
            method: Method.GET,
            headers: headers,
            params: params,
            payload: nil,
            block: nil)
        return request.syncRequest()
    }
    
    /**
    
    Executes an HTTP PUT request on the given URL.
    
    :param: url The URL to request.
    :param: headers HTTP headers.
    :param: params URL parameters, which become the request's query string.
    :param: payload A JSON dictionary or array to be used as the JSON body of the request.
    :param: block A reponse handler that takes a single HTTP.Response argument.
    
    */
    class func put(url: NSURL, headers: [String: String]? = nil, params: [String: String]? = nil, payload: JSONContainer?, block: ((Response) -> Void)?) {
        let request: Request = Request(url: url,
            method: Method.PUT,
            headers: headers,
            params: params,
            payload: payload,
            block: block)
        request.asyncRequest()
    }
    
    /**
    
    Executes an HTTP PUT request on the given URL.
    
    :param: url The URL to request.
    :param: headers HTTP headers.
    :param: params URL parameters, which become the request's query string.
    :param: payload A JSON dictionary or array to be used as the JSON body of the request.
    
    :returns: The HTTP.Response object representing the request's response.
    
    */
    class func put(url: NSURL, headers: [String: String]? = nil, params: [String: String]? = nil, payload: JSONContainer?) -> Response {
        let request: Request = Request(url: url,
            method: Method.PUT,
            headers: headers,
            params: params,
            payload: payload,
            block: nil)
        return request.syncRequest()
    }
    
    /**
    
    Executes an HTTP POST request on the given URL.
    
    :param: url The URL to request.
    :param: headers HTTP headers.
    :param: params URL parameters, which become the request's query string.
    :param: payload A JSON dictionary or array to be used as the JSON body of the request.
    :param: block A reponse handler that takes a single HTTP.Response argument.
    
    */
    class func post(url: NSURL, headers: [String: String]? = nil, params: [String: String]? = nil, payload: JSONContainer?, block: ((Response) -> Void)?) {
        let request: Request = Request(url: url,
            method: Method.POST,
            headers: headers,
            params: params,
            payload: payload,
            block: block)
        request.asyncRequest()
    }
    
    /**
    
    Executes an HTTP POST request on the given URL.
    
    :param: url The URL to request.
    :param: headers HTTP headers.
    :param: params URL parameters, which become the request's query string.
    :param: payload A JSON dictionary or array to be used as the JSON body of the request.
    
    :returns: The HTTP.Response object representing the request's response.
    
    */
    class func post(url: NSURL, headers: [String: String]? = nil, params: [String: String]? = nil, payload: JSONContainer?) -> Response {
        let request: Request = Request(url: url,
            method: Method.POST,
            headers: headers,
            params: params,
            payload: payload,
            block: nil)
        return request.syncRequest()
    }
    
    /**
    
    Executes an HTTP DELETE request on the given URL.
    
    :param: url The URL to request.
    :param: headers HTTP headers.
    :param: params URL parameters, which become the request's query string.
    :param: block A reponse handler that takes a single HTTP.Response argument.
    
    */
    class func delete(url: NSURL, headers: [String: String]? = nil, params: [String: String]? = nil, block: ((Response) -> Void)?) {
        let request: Request = Request(url: url,
            method: Method.GET,
            headers: headers,
            params: params,
            payload: nil,
            block: block)
        request.asyncRequest()
    }
    
    /**
    
    Executes an HTTP DELETE request on the given URL.
    
    :param: url The URL to request.
    :param: headers HTTP headers.
    :param: params URL parameters, which become the request's query string.
    
    :returns: The HTTP.Response object representing the request's response.
    
    */
    class func delete(url: NSURL, headers: [String: String]? = nil, params: [String: String]? = nil) -> Response {
        let request: Request = Request(url: url,
            method: Method.GET,
            headers: headers,
            params: params,
            payload: nil,
            block: nil)
        return request.syncRequest()
    }
}