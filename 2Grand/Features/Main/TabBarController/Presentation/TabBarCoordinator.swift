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
  
    private var window:UIWindow!
    init(window:UIWindow){
        self.window = window
    }
    func start() {
        let tabBar = TabBarController.init(nibName: R.nib.tabBarController.name, bundle: nil)
        tabBar.viewModel = TabBarViewModel(coordinator: self)
        window.rootViewController = tabBar
    }
    
}
