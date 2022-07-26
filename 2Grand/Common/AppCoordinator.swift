//
//  AppCoordinator.swift
//  2Grand
//
//  Created by Amin on 25/07/2022.
//

import Foundation
import UIKit

protocol Coordinating{
    func start()
}

struct AppCoordinator:Coordinating{
    
    let window:UIWindow!
    
    init(window:UIWindow){
        self.window = window
    }
    func start() {
//        let nav = UINavigationController()
//        nav.navigationBar.prefersLargeTitles = true
        let tabBarCoordinator = TabBarCoordinator(window: window)
        window.makeKeyAndVisible()
        tabBarCoordinator.start()
    }
}
