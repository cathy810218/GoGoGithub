//
//  UserSearchViewController.swift
//  GoGoGithub
//
//  Created by Cathy Oun on 4/6/17.
//  Copyright © 2017 cathyoun. All rights reserved.
//

import UIKit
import SafariServices

class UserSearchViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
//    let imageQueue = OperationQueue() // lazy loading
    
    var allUsers = [User]() {
        didSet {
            collectionView.reloadData()
        }
    }
    var searchedUsers: [User]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        
        fetchAllUsers()
    }
    
    func fetchAllUsers() {
        Github.shared.getUsers { (users) in
            if let users = users {
                self.allUsers = users
            }
        }
    }
}

extension UserSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            searchedUsers = allUsers.filter({$0.username.lowercased() == searchText.lowercased()})
            collectionView.reloadData()
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedUsers = allUsers.filter({$0.username.lowercased().contains(searchText.lowercased())})
        collectionView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            searchedUsers = allUsers.filter({$0.username.lowercased().contains(searchText.lowercased())})
            collectionView.reloadData()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text?.removeAll()
        searchedUsers = nil
        collectionView.reloadData()
        searchBar.resignFirstResponder()
    }
}

extension UserSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchedUsers?.count ?? allUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCollectionViewCell.identifier, for: indexPath) as! UserCollectionViewCell
        let userArray = searchedUsers ?? allUsers
        cell.user = userArray[indexPath.row]
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userArray = searchedUsers ?? allUsers
        let selectedUser = userArray[indexPath.row]
        let svc = SFSafariViewController(url: URL(string: selectedUser.url)!)
        present(svc, animated: true, completion: nil)
    }
}
