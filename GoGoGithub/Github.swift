//
//  Github.swift
//  GoGoGithub
//
//  Created by Cathy Oun on 4/3/17.
//  Copyright © 2017 cathyoun. All rights reserved.
//

import UIKit

let kOAuthBaseURLString = "https://github.com/login/oauth/"

typealias GithubOAuthCompletion = (_ success: Bool) -> Void // success flag

enum GithubAuthError: Error {
    case extractingCode
}
enum SaveOptions {
    case userDefaults
}

class Github {
    
    private let session: URLSession
    private var components: URLComponents
    
    static let shared = Github()
    
    private init() {
        
        // only be initialized in init method
        self.session = URLSession(configuration: .default)
        
        self.components = URLComponents()
        self.components.scheme = "https"
        self.components.host = "api.github.com"

    }
    
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
                            if let token = self.accessTokenFrom(dataString) {
                                if UserDefaults.standard.save(accessToken: token) {
                                    let queryItem = URLQueryItem(name: "access_token", value: token)
                                    self.components.queryItems = [queryItem]
                                }
                            }
                        }
                        complete(success: true)
                    }
                }).resume() // IMPORTANT!
            }
        } catch {
            print(error) // defined next to catch
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
    
    func getRepos(completion: @escaping ([Repo]?) -> Void){
        if let token = UserDefaults.standard.getAccessToken() {
            let queryItem = URLQueryItem(name: "access_token", value: token)
            self.components.queryItems = [queryItem]
        }
        func returnToMain(result: [Repo]?) {
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        self.components.path = "/user/repos"
        guard let url = self.components.url else {
            returnToMain(result: nil)
            return
        }
        
        self.session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                returnToMain(result: nil)
                return
            }
            
            if let data = data {
                var repos = [Repo]()
                
                do {
                    if let rootJson = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] {
                        
                        for eachJson in rootJson {
                            if let repo = Repo(json: eachJson) {
                                repos.append(repo)
                            }
                        }
                        returnToMain(result: repos)
                    }
                } catch {
                    print("parsing json error: \(error)")
                }
            }
        }.resume()
    }
    
    func accessTokenFrom(_ string: String) -> String? {
        if string.contains("access_token") {
            let components = string.components(separatedBy: "&")
            for component in components {
                print(component)
                
                if component.contains("access_token") {
                    let token = component.components(separatedBy: "=").last
                    
                    return token
                }
            }
        }
        return nil
    }
    
    func getUsers(completion: @escaping ([User]?) -> Void) {
        func returnToMain(result: [User]?) {
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        self.components.path = "/users"
        
        guard let url = self.components.url else {
            returnToMain(result: nil)
            return
        }
        print(url)
        
        self.session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                returnToMain(result: nil)
                return
            }
            
            if let data = data {
                var users = [User]()
                
                do {
                    if let rootJson = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] {
                        
                        for eachJson in rootJson {
                            if let user = User(json: eachJson) {
                                users.append(user)
                            }
                        }
                        returnToMain(result: users)
                    }
                } catch {
                    print("parsing json error: \(error)")
                }
            }
            }.resume()
    }
}
