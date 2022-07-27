//
//  HeadlineCoordinator.swift
//  2Grand
//
//  Created by Amin on 26/07/2022.
//

import UIKit
import SFSafeSymbols
import Moya
protocol HeadlineCoordinating:Coordinating{
    func navigateToDetails(withModel model:Article)
}

class HeadlineCoordinator:HeadlineCoordinating{
    
    private var tabBar : UITabBarController!
    init(tabBarController:UITabBarController){
        self.tabBar = tabBarController
    }
    
    func start() {
        let headlinesVC = HeadlineVC.init(nibName: R.nib.headlineVC.name, bundle: nil)
        let moya = MoyaProvider<NewsTarget>(plugins:[NetworkLoggerPlugin()])
        let repo = HeadlineRepository(remote: moya)
        let usecase = HeadlineUseCase(repo: repo)
        headlinesVC.viewModel = HeadlineViewModel(coordinator: self, usecase: usecase)
        headlinesVC.tabBarItem = UITabBarItem(title: "Headlines", image: UIImage(systemName: SFSymbol.filemenuAndCursorarrow.rawValue), tag: 2)
        
        guard let vcs = tabBar.viewControllers else{
            tabBar.setViewControllers([headlinesVC], animated: true)
            return
        }
        let all = vcs + [headlinesVC]
        tabBar.setViewControllers(all, animated: true)
    }
    
    func navigateToDetails(withModel model: Article) {
        let detailsCoordinator = DetailsCoordinator(tabBar: tabBar,model:model)
        detailsCoordinator.start()
    }
    

}
