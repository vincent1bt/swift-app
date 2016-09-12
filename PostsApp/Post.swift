//
//  Post.swift
//  PostsApp
//
//  Created by vicente rodriguez on 8/11/16.
//  Copyright © 2016 vicente rodriguez. All rights reserved.
//

import Foundation

struct Post {
    let id: String
    let title: String
    let body: String
    
    init(id: String, title: String, body: String) {
        self.id = id
        self.title = title
        self.body = body
    }
}