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
    
    var filteredRepos: [Repo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: RepoTableViewCell.identifier, bundle: Bundle.main), forCellReuseIdentifier: RepoTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        searchBar.delegate = self
        getAllRepos()
    }
    
    func getAllRepos() {
        Github.shared.getRepos { (repos) in
            if let repos = repos {
                self.allRepos = repos
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if DetailViewController.identifier == segue.identifier {
            guard let destinationController = segue.destination as? DetailViewController else {
                return
            }
            // Setting custom transition delegate to the destinationController
            destinationController.transitioningDelegate = self
            if let selectedIndex = self.tableView.indexPathForSelectedRow {
                let selectedRepo = self.allRepos[selectedIndex.row]
                destinationController.repo = selectedRepo
            }
        }
    }
}

//MARK: UISearchBarDelegate
extension RepoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            self.filteredRepos = self.allRepos.filter({$0.name.lowercased() == searchText.lowercased()})
            self.tableView.reloadData()
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredRepos = self.allRepos.filter({$0.name.lowercased().contains(searchText.lowercased())})
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            self.filteredRepos = self.allRepos.filter({$0.name.lowercased().contains(searchText.lowercased())})
            self.tableView.reloadData()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text?.removeAll()
        self.filteredRepos = nil
        self.tableView.reloadData()
        searchBar.resignFirstResponder()
    }
}


//MARK: UITableViewDelegate
extension RepoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRepos?.count ?? allRepos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepoTableViewCell.identifier, for: indexPath) as! RepoTableViewCell
        
        // To make sure that we are using the correct repo array
        var repoArray = filteredRepos ?? allRepos
        
        cell.repo = repoArray[indexPath.row]
        return cell
    }
 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: DetailViewController.identifier, sender: nil)
    }
}

//MARK: UIViewControllerTransitioningDelegate
extension RepoViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomTransition(duration: 1)
    }
}
