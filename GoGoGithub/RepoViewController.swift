//
//  RepoViewController.swift
//  GoGoGithub
//
//  Created by Cathy Oun on 4/4/17.
//  Copyright © 2017 cathyoun. All rights reserved.
//

import UIKit

class RepoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var allRepos = [Repo]() {
        didSet {
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        update()

    }
    
    func update() {
        Github.shared.getRepos { (repos) in
            if let repos = repos {
                self.allRepos = repos
            }
        }
    }

}

extension RepoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRepos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepoTableViewCell.identifier, for: indexPath) as! RepoTableViewCell
        cell.nameLabel.text = allRepos[indexPath.row].name
        cell.descriptionLabel.text = allRepos[indexPath.row].description
        cell.languageLabel.text = allRepos[indexPath.row].language

        return cell
    }
    
}
