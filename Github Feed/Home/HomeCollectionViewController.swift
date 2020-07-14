//
//  HomeCollectionViewController.swift
//  Github Feed
//
//  Created by Beniamin Idziak on 11/07/2020.
//  Copyright © 2020 Beniamin Idziak. All rights reserved.
//

import UIKit

private let reuseIdentifier = "FeedCell"

class HomeCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    
    private let apiHandler: GithubAPI = GithubAPI()
    private var datasource: [GithubEvent] = [] {
        didSet {
            filteredDatasource = datasource
        }
    }
    private var filteredDatasource: [GithubEvent] = []
    
    private var layoutMode: LayoutStyle = .list
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let initialLayout = getLayoutFor(style: .list)
        
        navigationItem.titleView = searchBar
        collectionView.setCollectionViewLayout(initialLayout, animated: false)
        collectionView.keyboardDismissMode = .onDrag
    }
    
    @IBAction func hideKeyboardIfNeeded(_ sender: UITapGestureRecognizer) {
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
    }
    
    @IBAction func toggleLayout(_ sender: UIBarButtonItem) {
        var newLayout: UICollectionViewCompositionalLayout
        
        if let newLayoutStyle = LayoutStyle(rawValue: layoutMode.rawValue + 1) {
            newLayout = getLayoutFor(style: newLayoutStyle)
            layoutMode = newLayoutStyle
            sender.image = UIImage(systemName: "list.dash")
        } else {
            newLayout = getLayoutFor(style: .list)
            layoutMode = .list
            sender.image = UIImage(systemName: "square.grid.2x2")
        }
        
        collectionView.setCollectionViewLayout(newLayout, animated: true) { _ in
            let visibleCells = self.collectionView.indexPathsForVisibleItems
            self.collectionView.reloadItems(at: visibleCells)
        }
    }
    
    private func getLayoutFor(style: LayoutStyle) -> UICollectionViewCompositionalLayout {
        var size: NSCollectionLayoutSize
        var horizontalItemCount: Int
        
        switch style {
        case .list:
            size = NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                heightDimension: NSCollectionLayoutDimension.absolute(45))
            horizontalItemCount = 1
        case .grid:
            size = NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                heightDimension: NSCollectionLayoutDimension.absolute(60))
            horizontalItemCount = 2
        }
        
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: horizontalItemCount)
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10.0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = 10
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func displayLoginOrUpdateFeed() {
        if Keychain.loadToken() == nil {
            let loginViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "Login") as! LoginViewController
            loginViewController.modalPresentationStyle = .fullScreen
            navigationController?.present(loginViewController, animated: true)
        } else {
            fetchDatasourceOrUserData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        displayLoginOrUpdateFeed()
    }
    
    func fetchDatasourceOrUserData() {
        if let username = UserDefaults.standard.string(forKey: "username") {
            fetchAndFillDatasource(for: "twostraws")
        } else {
            apiHandler.getCurrentUserData { response in
                switch response {
                case .success(let user):
                    UserDefaults.standard.set(user.login, forKey: "username")
                    self.fetchDatasourceOrUserData()
                case .failure(let error):
                    self.displayAlert(for: error)
                }
            }
        }
    }
    
    func fetchAndFillDatasource(for username: String) {
        apiHandler.getFeedData(for: username) { [weak self] result in
            switch result {
            case .success(let feed):
                self?.datasource = feed
                self?.layoutSafelyOnMainThread {
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                self?.displayAlert(for: error)
            }
        }
    }
    
    func updateFilter(_ query: String) {
        if query.isEmpty {
            filteredDatasource = datasource
        } else {
            filteredDatasource = datasource.filter { $0.eventDescription.string.lowercased().contains(query.lowercased()) }
        }
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRepositoryExplorer" {
            if let destinationController = segue.destination as? RepositoryTableViewController {
                destinationController.apiHandler = apiHandler
            }
        }
    }
}

extension HomeCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredDatasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCollectionViewCell
        
        if filteredDatasource.indices.contains(indexPath.item)  {
            cell.fillCell(with: filteredDatasource[indexPath.item])
        }
        
        return cell
    }
}

extension HomeCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.updateFilter(searchText)
    }
}
