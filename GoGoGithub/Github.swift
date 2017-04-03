//
//  Github.swift
//  GoGoGithub
//
//  Created by Cathy Oun on 4/3/17.
//  Copyright © 2017 cathyoun. All rights reserved.
//

import UIKit

enum GithubAuthError: Error {
    case extractingCode
}

let kOAuthBaseURLString = "https://github.com/login/oauth/"

class Github {
    
    static let shared = Github()
    
    func oAuthRequestWith(parameters: [String: String]) {
        var parameterString = "" // after the question mark
        for (key, value) in parameters {
            parameterString += "&\(key)=\(value)"
            
        }
        
        if let requestURL = URL(string: "\(kOAuthBaseURLString)authorize?client_id=\(kGithubClientID)\(parameterString)") {
            print(requestURL)
            
            UIApplication.shared.open(requestURL)
        }
        
    }
    
    func getCodeFrom(url: URL) throws -> String {
        
        // separate the key value paring
        guard let code = url.absoluteString.components(separatedBy: "=").last else {
            throw GithubAuthError.extractingCode
        }
        return code
    }
}
