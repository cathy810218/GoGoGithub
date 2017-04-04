//
//  GithubAuthViewController.swift
//  GoGoGithub
//
//  Created by Cathy Oun on 4/3/17.
//  Copyright © 2017 cathyoun. All rights reserved.
//

import UIKit


class GithubAuthViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    func updateUI() {
        if let _ = UserDefaults.standard.getAccessToken() {
            loginButton.isEnabled = false
        } else {
            loginButton.isEnabled = true
        }
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "access_token")
        updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didBecomeActive),
                                               name: .UIApplicationDidBecomeActive,
                                               object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    func didBecomeActive() {
        updateUI()
    }
    

    @IBAction func logInButtonPressed(_ sender: Any) {
        let parameters = ["scope": "email,user"]
        Github.shared.oAuthRequestWith(parameters: parameters)
        updateUI()
    }
    
    @IBAction func printTokenButtonPressed(_ sender: Any) {

    }

}
