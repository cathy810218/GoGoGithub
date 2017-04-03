//
//  FoundationExtension.swift
//  GoGoGithub
//
//  Created by Cathy Oun on 4/3/17.
//  Copyright © 2017 cathyoun. All rights reserved.
//

import Foundation

enum Keys: String {
   case accessToken = "access_token"
}

extension UserDefaults {
    
    func getAccessToken() -> String? {
        guard let token = UserDefaults.standard.string(forKey: Keys.accessToken.rawValue) else {
            return nil
        }
        return token
    }
    
    func save(accessToken: String) -> Bool {
        UserDefaults.standard.set(accessToken, forKey: Keys.accessToken.rawValue)
        return UserDefaults.standard.synchronize()
    }
}
