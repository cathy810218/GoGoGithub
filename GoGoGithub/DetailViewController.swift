//
//  DetailViewController.swift
//  GoGoGithub
//
//  Created by Cathy Oun on 4/5/17.
//  Copyright © 2017 cathyoun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var createDateLabel: UILabel!
    @IBOutlet weak var numOfStarsLabel: UILabel!
    @IBOutlet weak var isForkLabel: UILabel!
    
    var repo: Repo?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let repo = repo {
            repoNameLabel.text = repo.name
            descriptionLabel.text = repo.description
            languageLabel.text = repo.language
            createDateLabel.text = repo.date
            numOfStarsLabel.text = "Stars: \(repo.numOfStars)"
            isForkLabel.text = repo.isForked ? "Forked" : "Not forked"
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
