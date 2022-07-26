//
//  DetailsCoordinator.swift
//  2Grand
//
//  Created by Amin on 26/07/2022.
//

import Foundation
import UIKit

protocol DetailsCoordinating:Coordinating{
    func dismiss()
}

struct DetailsCoordinator:DetailsCoordinating{
 
    private var tabBar:UITabBarController!
    private var model:Article!
    init(tabBar:UITabBarController,model:Article){
        self.tabBar = tabBar
        self.model = model
    }
    
    func start() {
        let vc = DetailsVC.init(nibName: R.nib.detailsVC.name, bundle: nil)
        vc.model = self.model
        vc.viewModel = DetailsViewModel(coordintor: self)
        vc.modalPresentationStyle = .fullScreen
        tabBar.present(vc, animated: true, completion: nil)
    }
    func dismiss() {
        tabBar.dismiss(animated: true, completion: nil)
    }
    
    
}
