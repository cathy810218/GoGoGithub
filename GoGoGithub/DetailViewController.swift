//
//  DetailViewController.swift
//  GoGoGithub
//
//  Created by Cathy Oun on 4/5/17.
//  Copyright © 2017 cathyoun. All rights reserved.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController {

    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var createDateLabel: UILabel!
    @IBOutlet weak var numOfStarsLabel: UILabel!
    @IBOutlet weak var isForkLabel: UILabel!
    
    var repo: Repo!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        repoNameLabel.text = repo.name
        descriptionLabel.text = repo.description
        languageLabel.text = repo.language
        createDateLabel.text = repo.date
        numOfStarsLabel.text = "Stars: \(repo.numOfStars)"
        isForkLabel.text = repo.isForked ? "Forked" : "Not forked"
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openSafariPressed(_ sender: Any) {
        let svc = SFSafariViewController(url: URL(string: repo.url)!)
        present(svc, animated: true, completion: nil)
    }
}
