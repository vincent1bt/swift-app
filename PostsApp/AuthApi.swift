//
//  AuthApi.swift
//  PostsApp
//
//  Created by vicente rodriguez on 8/10/16.
//  Copyright © 2016 vicente rodriguez. All rights reserved.
//

import Foundation

protocol APIAuthProtocol {
    func errorInRequest(error: String)
    func didLogin()
    func didCreateUser()
}

struct AuthAPI {
    var delegate: APIAuthProtocol?
    private let authRequest: AuthRequest = AuthRequest()
    
    func createUser(email: String, password: String, passwordConfirmation: String) {
        authRequest.createUser(email, password: password, passwordConfirmation: passwordConfirmation) { (json, error) in
            guard error == nil else {
                self.delegate?.errorInRequest(error!.description)
                return
            }
            let token = json!["auth_token"].stringValue
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setValue(token, forKey: "Token")
            self.delegate?.didCreateUser()
        }
    }
    
    func login(email: String, password: String) {
        let params: String = "{\"email\": \"\(email)\", \"password\": \"\(password)\"}"
        authRequest.login(params) { (json, error) in
            guard error == nil else {
                self.delegate?.errorInRequest(error!.description)
                return
            }
            let token = json!["auth_token"].stringValue
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setValue(token, forKey: "Token")
            self.delegate?.didLogin()
        }
    }
}



