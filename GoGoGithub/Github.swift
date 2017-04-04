//
//  Github.swift
//  GoGoGithub
//
//  Created by Cathy Oun on 4/3/17.
//  Copyright © 2017 cathyoun. All rights reserved.
//

import UIKit

let kOAuthBaseURLString = "https://github.com/login/oauth/"

typealias GithubOAuthCompletion = (Bool) -> Void // success flag

enum GithubAuthError: Error {
    case extractingCode
}
enum SaveOptions {
    case userDefaults
}

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
    
    func tokenRequestFor(url: URL, saveOptions: SaveOptions, completion: @escaping GithubOAuthCompletion) {
        
        // helper method to make sure the completion is being called on the main thread
        func complete(success: Bool) {
            OperationQueue.main.addOperation {
                completion(success)
            }
        }
        
        do {
            let code = try self.getCodeFrom(url: url)
            let requestString = "\(kOAuthBaseURLString)access_token?client_id=\(kGithubClientID)&client_secret=\(kGithubClientSecret)&code=\(code)"
            
            if let requestURL = URL(string: requestString) {
                let session = URLSession(configuration: URLSessionConfiguration.default)
                session.dataTask(with: requestURL, completionHandler: { (data, response, error) in
                    if let error = error {
                        complete(success: false)
                        print("error: \(error)")
                    }
                    
                    guard let data = data else {
                        complete(success: false)
                        return
                    }
                    
                    if let dataString = String(data: data, encoding: .utf8 ) {
                        if (saveOptions == SaveOptions.userDefaults) {
                            if UserDefaults.standard.save(accessToken: dataString) {
                                print("Save access token")
                            }
                        }
                        complete(success: true)
                    }
                }).resume() // IMPORTANT!

            }
            
        } catch {
            print(error) // defined next to error
            complete(success: false)
        }
    }
    
    private func getCodeFrom(url: URL) throws -> String {
        
        // separate the key value paring
        guard let code = url.absoluteString.components(separatedBy: "=").last else {
            throw GithubAuthError.extractingCode
        }
        return code
    }
}
