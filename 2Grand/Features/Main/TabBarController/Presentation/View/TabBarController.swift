//
//  TabBarController.swift
//  2Grand
//
//  Created by Amin on 24/07/2022.
//

import UIKit
import RxSwift
import RxCocoa
class TabBarController: UITabBarController {


    private var bag:DisposeBag!
    var viewModel:TabBarViewModel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        bag = DisposeBag()
        
        let homeCoordinator = HomeCoordinator(tabBarController: self)
        homeCoordinator.start()
        
        let headlinesCoordinator = HeadlineCoordinator(tabBarController: self)
        headlinesCoordinator.start()
        

    }

}


