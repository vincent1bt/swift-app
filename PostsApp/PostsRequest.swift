//
//  PostsRequest.swift
//  PostsApp
//
//  Created by vicente rodriguez on 8/23/16.
//  Copyright © 2016 vicente rodriguez. All rights reserved.
//

import Foundation

struct PostsRequest {
    private let requestAPI: RequestAPI = RequestAPI()
    
    func deletePost(id: String, token: String?, onComplete: RequestResponse) {
        guard let request = requestAPI.buildRequest("posts/\(id)") else {
            return
        }
        
        request.setValue(token, forHTTPHeaderField: "Authorization")
        requestAPI.makeRequest(request) { (json, error) in
            onComplete(json, error)
        }
    }
    
    func updatePost(id: String, post: Post, token: String?, onComplete: RequestResponse) {
        guard let request = requestAPI.buildRequest("posts/\(id)") else {
            return
        }
        request.HTTPMethod = "PUT"
        let params: String = "{\"post\": { \"title\": \"\(post.title)\", \"body\": \"\(post.body)\"}}"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion:true)
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        requestAPI.makeRequest(request) { (json, error) in
            onComplete(json, error)
        }
        
    }
    
    func createPost(title: String, body: String, token: String?, onComplete: RequestResponse) {
        guard let request = requestAPI.buildRequest("posts") else {
            return
        }
        request.HTTPMethod = "POST"
        let params: String = "{\"post\": { \"title\": \"\(title)\", \"body\": \"\(body)\"}}"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion:true)
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        requestAPI.makeRequest(request) { (json, error) in
            onComplete(json, error)
        }
    }
    
    func getPosts(onComplete: RequestResponse) {
        guard let request = requestAPI.buildRequest("posts") else {
            return
        }
        request.HTTPMethod = "GET"
        requestAPI.makeRequest(request) { (json, error) in
            onComplete(json, error)
        }
    }
}