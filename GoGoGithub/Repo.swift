//
//  Repo.swift
//  GoGoGithub
//
//  Created by Cathy Oun on 4/4/17.
//  Copyright © 2017 cathyoun. All rights reserved.
//

import UIKit

class Repo {
    
    let name: String
    let description: String?
    let language: String?
    
    init?(json: [String: Any]) {
        
        if let name = json["name"] as? String {
            self.name = name
        } else {
            return nil
        }
        if let description = json["description"] as? String, let language = json["language"] as? String {
            self.description = description
            self.language = language
        } else {
            self.description = "No description"
            self.language = "N/A"
        }
    }
}
