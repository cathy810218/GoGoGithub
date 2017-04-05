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
        searchBar.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tableView.addGestureRecognizer(tap)
        update()
    }
    
    func update() {
        Github.shared.getRepos { (repos) in
            if let repos = repos {
                self.allRepos = repos
            }
        }
    }
    
    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
}


extension RepoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var repos = [Repo]()
        for repo in allRepos {
            let name1 = repo.name.lowercased().replacingOccurrences(of: " ", with: "")
            let name2 = searchBar.text?.lowercased().replacingOccurrences(of: " ", with: "")
            if name1 == name2 {
                repos.append(repo)
            }
        }
        allRepos = repos
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            update()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
     }
}


//MARK: UITableViewDataSource
extension RepoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRepos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepoTableViewCell.identifier, for: indexPath) as! RepoTableViewCell
        cell.nameLabel.text = allRepos[indexPath.row].name
        cell.descriptionLabel.text = allRepos[indexPath.row].description
        cell.languageLabel.text = allRepos[indexPath.row].language
        cell.dateLabel.text = allRepos[indexPath.row].date
        return cell
    }
 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}
