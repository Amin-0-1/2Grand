//
//  TabBarController.swift
//  2Grand
//
//  Created by Amin on 24/07/2022.
//

import UIKit
import RxSwift
import RxCocoa
import SFSafeSymbols
class TabBarController: UITabBarController {

    private var bag:DisposeBag!
    override func viewDidLoad() {
        super.viewDidLoad()
        bag = DisposeBag()
        title = "Home"
        let homeVC = HomeVC.init(nibName: R.nib.homeVC.name, bundle: nil)
        let headlinesVC = HeadlineVC.init(nibName: R.nib.headlineVC.name, bundle: nil)
        
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: SFSymbol.homekit.rawValue), tag: 1)
        headlinesVC.tabBarItem = UITabBarItem(title: "Headlines", image: UIImage(systemName: SFSymbol.filemenuAndCursorarrow.rawValue), tag: 2)
    
        setViewControllers([homeVC,headlinesVC], animated: true)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        title = item.title
    }
}


