// The MIT License (MIT)
//
// Copyright (c) 2017 Ruike Gong
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Alamofire

public enum RKPrioritization {
    //
    case fifo
    //
    case lifo
}

open class RKConfiguration {

    open var baseURL: URL?
    //
    open let maximumActiveRequestCount: Int
    //
    open let prioritization: RKPrioritization
    //
    open let configuration: URLSessionConfiguration
    //
    open let trustPolicyManager: ServerTrustPolicyManager?
    
    public init(baseURL: URL?,
                maximumActiveRequestCount: Int = 3,
                prioritization: RKPrioritization = .fifo,
                configuration: URLSessionConfiguration = RKConfiguration.defaultURLSessionConfiguration(),
                trustPolicyManager: ServerTrustPolicyManager? = nil) {
        //
        self.baseURL                    = baseURL
        self.maximumActiveRequestCount  = maximumActiveRequestCount
        self.prioritization             = prioritization
        self.configuration              = configuration
        self.trustPolicyManager         = trustPolicyManager
    }
    
    open class func defaultURLSessionConfiguration() -> URLSessionConfiguration {
        //
        let configuration = URLSessionConfiguration.default
        
        configuration.httpAdditionalHeaders         = SessionManager.defaultHTTPHeaders
        configuration.httpShouldUsePipelining       = true
        configuration.httpShouldSetCookies          = false
        
        configuration.requestCachePolicy            = .useProtocolCachePolicy
        configuration.allowsCellularAccess          = true
        configuration.timeoutIntervalForResource    = 15
        
        configuration.urlCache = defaultURLCache()
        
        return configuration
    }
    
    open class func defaultURLCache() -> URLCache {
        //
        return URLCache(
            memoryCapacity: 20 * 1024 * 1024, // 20 MB
            diskCapacity: 150 * 1024 * 1024,  // 150 MB
            diskPath: "cn.rk.request.url.cache"
        )
    }
    
}
