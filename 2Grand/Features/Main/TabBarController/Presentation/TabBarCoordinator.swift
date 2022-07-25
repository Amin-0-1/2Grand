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
        let vc = TabBarController.init(nibName: R.nib.tabBarController.name, bundle: nil)
        nav.pushViewController(vc, animated: true)
    }
}
