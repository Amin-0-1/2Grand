//
//  DetailsCoordinator.swift
//  2Grand
//
//  Created by Amin on 26/07/2022.
//

import Foundation
import UIKit

protocol DetailsCoordinating:Coordinating{
    
}

struct DetailsCoordinator:DetailsCoordinating{
    
    private var nav:UINavigationController!
    private var model:Article!
    init(nav:UINavigationController,model:Article){
        self.nav = nav
        self.model = model
    }
    
    func start() {
        let vc = DetailsVC.init(nibName: R.nib.detailsVC.name, bundle: nil)
        vc.model = self.model
        nav.pushViewController(vc, animated: true)
    }
    
}
