//
//  RepositoryTableViewController.swift
//  Github Feed
//
//  Created by Beniamin Idziak on 13/07/2020.
//  Copyright © 2020 Beniamin Idziak. All rights reserved.
//

import UIKit

class RepositoryTableViewController: UITableViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    
    var datasource: [Repository] = [] {
        didSet {
            layoutSafelyOnMainThread {
                self.tableView.reloadData()
            }
        }
    }
    
    var apiHandler: GithubAPI?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.keyboardDismissMode = .onDrag
        navigationItem.titleView = searchBar
    }
    
    deinit {
        apiHandler = nil
    }
    
    @IBAction func hideKeyboardIfNeeded(_ sender: UITapGestureRecognizer) {
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath) as! RepositoryTableViewCell
        
        if datasource.indices.contains(indexPath.item) {
            let item = datasource[indexPath.item]
            cell.fillCell(with: item)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = datasource[indexPath.item]
        performSegue(withIdentifier: "showRepositoryDetails", sender: item)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRepositoryDetails" {
            if let item = sender as? Repository, let destination = segue.destination as? RepositoryDetailsViewController {
                destination.item = item
            }
        }
    }
    
    @objc func updateDatasourceWith(searchText text: String) {
        if text.isEmpty {
            datasource = []
        } else {
            apiHandler?.performRequest(for: .repos(query: text)) { [weak self] (response: Result<GithubRepos, Error>) in
                switch response {
                case .success(let repos):
                    self?.datasource = repos.items ?? []
                case .failure(let error):
                    self?.displayAlert(for: error)
                }
            }
        }
    }
}

extension RepositoryTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(updateDatasourceWith(searchText:)), object: searchText)
        perform(#selector(updateDatasourceWith(searchText:)), with: searchText, afterDelay: 0.75)
    }
}
