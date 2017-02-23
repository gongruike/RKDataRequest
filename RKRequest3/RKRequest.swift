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

open class RKRequest<Type>: RKRequestable {

    public typealias RKCompletionHandler = (Result<Type>) -> Void
    
    public typealias RKProgressHandler = Request.ProgressHandler
    
    open var url: URLConvertible
    
    open var method: HTTPMethod = .get
    
    open var parameters: Parameters = [:]
    
    open var encoding: ParameterEncoding = URLEncoding.default
    
    open var headers: HTTPHeaders = [:]

    open var request: Request?
    
    open var requestQueue: RKRequestQueueType?

    open var completionHandler: RKCompletionHandler?

    init(url: URLConvertible, completionHandler: RKCompletionHandler?) {
        //
        self.url = url
        self.completionHandler = completionHandler
    }
    
    //
    open func serializeRequest(in requestQueue: RKRequestQueueType) {
        //
    }
    
    open func start() {
        //
        guard let request = request else { return }
        //
        parseData()
        //
        request.resume()
        //
        requestQueue?.onSendRequest(self)
    }
    
    open func cancel() {
        //
        guard let request = request else { return }
        //
        request.cancel()
        //
        deliverResult()
    }
    
    /*
         Parse data from server into ResponseType，
         ResponseType can be JSON, String, NSData, SwiftyJSON and so on.
     */
    func parseData() {
        //
    }
    
    /*
         Parse response to the Type or generate a error
     */
    func parseResponse() -> Result<Type> {
        //
        return Result.failure(RKError.incorrectRequestType)
    }
    
    /*
         Deliver result or error in the main thread
     */
    func deliverResult() {
        //
        DispatchQueue.global(qos: .default).async {
            //
            let result = self.parseResponse()
            //
            DispatchQueue.main.async {
                //
                self.completionHandler?(result)
            }
            //
            self.requestQueue?.onFinishRequest(self)
        }
    }
    
}
