//
//  Errors.swift
//  PostsApp
//
//  Created by vicente rodriguez on 8/10/16.
//  Copyright © 2016 vicente rodriguez. All rights reserved.
//

import Foundation

struct RequestError {
    let description: String
    let code: Int
    
    init(description: String, code: Int) {
        self.description = description
        self.code = code
    }
    
    init() {
        self.description = "Server error"
        self.code = 500
    }
}