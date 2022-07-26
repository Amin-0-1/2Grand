//
//  TabBarController.swift
//  2Grand
//
//  Created by Amin on 24/07/2022.
//

import UIKit
import RxSwift
import RxCocoa
class TabBarController: UITabBarController, UISearchResultsUpdating, UISearchControllerDelegate {


    private var bag:DisposeBag!
    var viewModel:TabBarViewModel!
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search for anything..."
        sc.searchBar.autocapitalizationType = .allCharacters
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bag = DisposeBag()
        
        title = "Home"
        navigationItem.searchController = searchController
        
        let homeCoordinator = HomeCoordinator(tabBarController: self)
        homeCoordinator.start()
        
        let headlinesCoordinator = HeadlineCoordinator(tabBarController: self)
        headlinesCoordinator.start()
        

    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        title = item.title
        if item.tag == 2{
            navigationItem.searchController = nil
        }else{
            navigationItem.searchController = searchController
        }
    }
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}


