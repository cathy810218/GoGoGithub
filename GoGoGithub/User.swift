//
//  User.swift
//  GoGoGithub
//
//  Created by Cathy Oun on 4/6/17.
//  Copyright © 2017 cathyoun. All rights reserved.
//

import UIKit

class User {
    
    let avatarURL: String
    let username: String
    let url: String
    
    init?(json: [String: Any]) {
        
        if let avatarURL = json["avatar_url"] as? String, let username = json["login"] as? String, let url = json["html_url"] as? String {
            self.avatarURL = avatarURL
            self.username = username
            self.url = url
        } else {
            return nil
        }
    }
}
