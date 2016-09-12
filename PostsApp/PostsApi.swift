//
//  Api.swift
//  PostsApp
//
//  Created by vicente rodriguez on 8/8/16.
//  Copyright © 2016 vicente rodriguez. All rights reserved.
//

import Foundation


protocol PostsAPIProtocol {
    func errorInRequest(error: String)
    func didGetPosts(data: [Post])
    func didCreatePost(post: Post)
    func loginRequired()
    func didUpdatePost(post: Post)
    func deletePost(row: Int)
}

struct PostsAPI {
    var delegate: PostsAPIProtocol?
    private let authAPI: AuthAPI = AuthAPI()
    private let postsRequest: PostsRequest = PostsRequest()
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    func getPosts() {
        postsRequest.getPosts { (json, error) in
            guard error == nil else {
                self.delegate?.errorInRequest(error!.description)
                return
            }
            let data = json!["posts"].arrayValue
            let posts = data.map({ (post) -> Post in
                Post(id: post["id"].stringValue, title: post["title"].stringValue, body: post["body"].stringValue)
            })
            self.delegate?.didGetPosts(posts)
        }
    }
    
    func createPost(title: String, body: String) {
        let token = defaults.stringForKey("Token")
        
        postsRequest.createPost(title, body: body, token: token) { (json, error) in
            if error != nil && error?.description == "Token Expired" {
                self.delegate?.loginRequired()
                return
            }
            
            guard error == nil else {
                self.delegate?.errorInRequest(error!.description)
                return
            }
            let post = json!["post"].dictionaryValue
            let id = post["id"]!.stringValue
            let title = post["title"]!.stringValue
            let body = post["body"]!.stringValue
            let newPost: Post = Post(id: id, title: title, body: body)
            self.delegate?.didCreatePost(newPost)
        }
    }
    
    func updatePost(id: String, post: Post) {
        let token = defaults.stringForKey("Token")
        postsRequest.updatePost(id, post: post, token: token) { (json, error) in
            if error != nil && error?.description == "Token Expired" {
                self.delegate?.loginRequired()
                return
            }
            
            guard error == nil else {
                self.delegate?.errorInRequest(error!.description)
                return
            }
            
            let id = json!["post"].dictionaryValue["id"]?.stringValue
            let title = json!["post"].dictionaryValue["title"]?.stringValue
            let body = json!["post"].dictionaryValue["body"]?.stringValue
            let post: Post = Post(id: id!, title: title!, body: body!)
            self.delegate?.didUpdatePost(post)
        }
    }
    
    func deletePost(id: String, row: Int) {
        let token = defaults.stringForKey("Token")
        postsRequest.deletePost(id, token: token) { (json, error) in
            if error != nil && error?.description == "Token Expired" {
                self.delegate?.loginRequired()
                return
            }
            
            guard error == nil else {
                self.delegate?.errorInRequest(error!.description)
                return
            }
            self.delegate?.deletePost(row)
        }
    }
}