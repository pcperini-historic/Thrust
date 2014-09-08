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
    var urlSerializedString: String {
        get {
            var serializedString: String? = nil
            for (key, value) in self {
                let encodedKey = "\(key)".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
                let encodedValue = "\(value)".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
                
                if serializedString == nil {
                    serializedString = "\(encodedKey)=\(encodedValue)"
                } else {
                    serializedString! += "&\(encodedKey)=\(encodedValue)"
                }
            }
            
            return serializedString!
        }
    }
}

class HTTP {
    // MARK: - Responses
    struct Response: Printable {
        // MARK: - Properties
        // MARK: Request Information
        var requestURL: NSURL
        var requestBody: NSData
        
        // MARK: Response Information
        var status: Int?
        var data: NSData?
        
        var string: String? {
            return NSString(data: self.data!, encoding: NSUTF8StringEncoding) as String
        }
        
        var object: JSONContainer? {
            return self.string?.jsonObject
        }
        
        var description: String {
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
            let requestBody: NSData = self.payload?.jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true) ?? NSData()
            
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
        mutating func addGETRequest(url: NSURL, headers: [String: String]? = nil, params: [String: String]? = nil, block: ((Response) -> Void)?) {
            self.addRequest(url,
                method: Method.GET,
                headers: headers,
                params: params,
                payload: nil,
                block: block)
        }
        
        mutating func addPUTRequest(url: NSURL, headers: [String: String]? = nil, params: [String: String]? = nil, payload: JSONContainer?, block: ((Response) -> Void)?) {
            self.addRequest(url,
                method: Method.PUT,
                headers: headers,
                params: params,
                payload: payload,
                block: block)
        }
        
        mutating func addPOSTRequest(url: NSURL, headers: [String: String]? = nil, params: [String: String]? = nil, payload: JSONContainer?, block: ((Response) -> Void)?) {
            self.addRequest(url,
                method: Method.POST,
                headers: headers,
                params: params,
                payload: payload,
                block: block)
        }
        
        mutating func addDELETERequest(url: NSURL, headers: [String: String]? = nil, params: [String: String]? = nil, block: ((Response) -> Void)?) {
            self.addRequest(url,
                method: Method.DELETE,
                headers: headers,
                params: params,
                payload: nil,
                block: block)
        }

        private mutating func addRequest(url: NSURL, method: Method, headers: [String: String]? = nil, params: [String: String]? = nil, payload: JSONContainer?, block: ((Response) -> Void)?) {
            let request: Request = Request(url: url,
                method: method,
                headers: headers,
                params: params,
                payload: payload,
                block: block)
            
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
    class func get(url: NSURL, headers: [String: String]? = nil, params: [String: String]? = nil, block: ((Response) -> Void)?) {
        let request: Request = Request(url: url,
            method: Method.GET,
            headers: headers,
            params: params,
            payload: nil,
            block: block)
        request.asyncRequest()
    }
    
    class func get(url: NSURL, headers: [String: String]? = nil, params: [String: String]? = nil) -> Response {
        let request: Request = Request(url: url,
            method: Method.GET,
            headers: headers,
            params: params,
            payload: nil,
            block: nil)
        return request.syncRequest()
    }
    
    class func put(url: NSURL, headers: [String: String]? = nil, params: [String: String]? = nil, payload: JSONContainer?, block: ((Response) -> Void)?) {
        let request: Request = Request(url: url,
            method: Method.PUT,
            headers: headers,
            params: params,
            payload: payload,
            block: block)
        request.asyncRequest()
    }
    
    class func put(url: NSURL, headers: [String: String]? = nil, params: [String: String]? = nil, payload: JSONContainer?) -> Response {
        let request: Request = Request(url: url,
            method: Method.PUT,
            headers: headers,
            params: params,
            payload: payload,
            block: nil)
        return request.syncRequest()
    }
    
    class func post(url: NSURL, headers: [String: String]? = nil, params: [String: String]? = nil, payload: JSONContainer?, block: ((Response) -> Void)?) {
        let request: Request = Request(url: url,
            method: Method.POST,
            headers: headers,
            params: params,
            payload: payload,
            block: block)
        request.asyncRequest()
    }
    
    class func post(url: NSURL, headers: [String: String]? = nil, params: [String: String]? = nil, payload: JSONContainer?) -> Response {
        let request: Request = Request(url: url,
            method: Method.POST,
            headers: headers,
            params: params,
            payload: payload,
            block: nil)
        return request.syncRequest()
    }
    
    class func delete(url: NSURL, headers: [String: String]? = nil, params: [String: String]? = nil, block: ((Response) -> Void)?) {
        let request: Request = Request(url: url,
            method: Method.GET,
            headers: headers,
            params: params,
            payload: nil,
            block: block)
        request.asyncRequest()
    }
    
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