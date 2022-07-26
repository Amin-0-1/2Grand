//
//  TabBarCoordinator.swift
//  2Grand
//
//  Created by Amin on 24/07/2022.
//

import Foundation
import UIKit

protocol TabBarCoordinating:Coordinating{

}
struct TabBarCoordinator:TabBarCoordinating{
  
    let nav : UINavigationController!
    
    init(nav:UINavigationController){
        self.nav = nav
    }
    
    func start() {
        let tabBar = TabBarController.init(nibName: R.nib.tabBarController.name, bundle: nil)
        tabBar.viewModel = TabBarViewModel(coordinator: self)
        nav.pushViewController(tabBar, animated: true)
    }
    
}
