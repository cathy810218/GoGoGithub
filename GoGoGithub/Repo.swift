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
    let date: String
    let isForked: Bool
    let numOfStars: Int
    
    init?(json: [String: Any]) {
        
        if let name = json["name"] as? String, let date = json["created_at"] as? String, let isForked = json["fork"] as? Bool, let numOfStars = json["stargazers_count"] as? Int {
            self.name = name
            let index = date.range(of: "T", options: .backwards)?.lowerBound
            let newDate = date.substring(to: index!)
            self.date = String(describing: newDate)
            self.isForked = isForked
            self.numOfStars = numOfStars
        } else {
            return nil
        }
        if let description = json["description"] as? String {
            self.description = description
        } else {
            self.description = "No description"
        }
        
        if let language = json["language"] as? String {
            self.language = language
        } else {
            self.language = "N/A"
        }
        
    }
}
