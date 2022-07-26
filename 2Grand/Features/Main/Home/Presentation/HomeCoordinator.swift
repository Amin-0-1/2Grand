//
//  HomeCoordinator.swift
//  2Grand
//
//  Created by Amin on 26/07/2022.
//

import Foundation
import UIKit
import SFSafeSymbols
import Moya

protocol HomeCoordinating:Coordinating{
    func navigateToDetails(withModel model:Article)
}

struct HomeCoordinator:HomeCoordinating{
 
    private var tabBar : UITabBarController!
    init(tabBarController:UITabBarController){
        self.tabBar = tabBarController
    }
    func start() {

        let homeVC = HomeVC.init(nibName: R.nib.homeVC.name, bundle: nil)
        let repo = HomeRepository(remote: MoyaProvider(plugins:[NetworkLoggerPlugin()]))
        let usecase = HomeUseCase(repo: repo)
        homeVC.viewModel = HomeViewModel(coordinator: self, usecase: usecase)
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: SFSymbol.homekit.rawValue), tag: 1)
        
        guard let vcs = tabBar.viewControllers else {
            tabBar.setViewControllers([homeVC], animated: true)
            return
        }
        
        let all = vcs + [homeVC]
        tabBar.setViewControllers(all, animated: true)
    }
    
    func navigateToDetails(withModel model: Article) {
        guard let nav = tabBar.navigationController else {return}
        let detailsCoordinator = DetailsCoordinator(nav: nav,model:model)
        detailsCoordinator.start()
        
    }
    
}
