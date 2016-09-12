//
//  Request.swift
//  PostsApp
//
//  Created by vicente rodriguez on 8/8/16.
//  Copyright © 2016 vicente rodriguez. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias RequestResponse = (JSON?, RequestError?) -> Void

struct RequestAPI {
    private let mainPoint: String = "http://localhost:3000/api/"
    
    func buildRequest(url: String) -> NSMutableURLRequest? {
        guard let url = NSURL(string: "\(self.mainPoint)\(url)") else {
            return nil
        }
        let request = NSMutableURLRequest(URL: url)
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    func makeRequest(request: NSMutableURLRequest, onComplete: RequestResponse) {
        let session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            guard let unwrapperData = data else {
                let error = RequestError()
                onComplete(nil, error)
                return
            }
            
            let json = JSON(data: unwrapperData)
            if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 && httpResponse.statusCode != 201 {
                    let error = self.manageCodeError(httpResponse.statusCode, json: json)
                    onComplete(nil, error)
                    return
                }
            }
            onComplete(json, nil)
        }
        task.resume()
    }
    
    private func manageCodeError(code: Int, json: JSON) -> RequestError {
        let descriptionError = json["error"].rawString(NSUTF8StringEncoding, options: NSJSONWritingOptions.PrettyPrinted)
        print(descriptionError)
        return RequestError(description: descriptionError!, code: code)
    }
}



