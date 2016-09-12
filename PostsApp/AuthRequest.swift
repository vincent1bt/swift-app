//
//  AuthRequest.swift
//  PostsApp
//
//  Created by vicente rodriguez on 8/23/16.
//  Copyright © 2016 vicente rodriguez. All rights reserved.
//

import Foundation


struct AuthRequest {
    private let requestAPI: RequestAPI = RequestAPI()
    func createUser(email: String, password: String, passwordConfirmation: String, onComplete: RequestResponse) {
        guard let request = requestAPI.buildRequest("signup") else {
            return
        }
        let params: String = "{\"user\": { \"name\": \"vincent\", \"email\": \"\(email)\", \"password\": \"\(password)\", \"password_confirmation\": \"\(passwordConfirmation)\"}}"
        request.HTTPMethod = "POST"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion:true)
        requestAPI.makeRequest(request) { (json, error) in
            onComplete(json, error)
        }
    }
    
    func login(params: String, onComplete: RequestResponse) {
        guard let request = requestAPI.buildRequest("login") else {
            return
        }
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion:true)
        request.HTTPMethod = "POST"
        requestAPI.makeRequest(request) { (json, error) in
            onComplete(json, error)
        }
    }
}