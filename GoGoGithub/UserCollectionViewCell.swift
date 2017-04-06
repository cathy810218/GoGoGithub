//
//  UserCollectionViewCell.swift
//  GoGoGithub
//
//  Created by Cathy Oun on 4/6/17.
//  Copyright © 2017 cathyoun. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var user: User? {
        didSet {
            if let user = user {
                self.usernameLabel.text = user.username
                UIImage.fetchImageWith(user.avatarURL, callback: { (avatarImage) in
                    self.avatarImageView.image = avatarImage
                })
            }
        }
    }
}
