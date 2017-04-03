//
//  GithubAuthViewController.swift
//  GoGoGithub
//
//  Created by Cathy Oun on 4/3/17.
//  Copyright © 2017 cathyoun. All rights reserved.
//

import UIKit

class GithubAuthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func logInButtonPressed(_ sender: Any) {
        
        let parameters = ["scope": "email,user"]
        Github.shared.oAuthRequestWith(parameters: parameters)
    }
    
    @IBAction func printTokenButtonPressed(_ sender: Any) {

    }
}
