//
//  FoundationExtension.swift
//  GoGoGithub
//
//  Created by Cathy Oun on 4/3/17.
//  Copyright © 2017 cathyoun. All rights reserved.
//

import Foundation
import UIKit

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


extension UIResponder {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIImage {
    
    class func fetchImageWith(_ urlString: String, callback: @escaping (UIImage?) -> Void) {
        OperationQueue().addOperation {
            guard let url = URL(string: urlString) else {
                callback(nil)
                return
            }
            if let data = try? Data(contentsOf: url) {
                let image = UIImage(data: data)
                OperationQueue.main.addOperation {
                    callback(image)
                }
            } else {
                OperationQueue.main.addOperation {
                    callback(nil)
                }
            }
        }
    }
}

