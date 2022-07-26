//
//  TabBarViewModel.swift
//  2Grand
//
//  Created by Amin on 26/07/2022.
//

import Foundation
import RxSwift
import RxCocoa

protocol TabBarInput{
}

struct TabBarVMInput:TabBarInput{
    
    init(){
    }
}

protocol TabBarVMProtocol{
    var input:TabBarVMInput! { get }
}

class TabBarViewModel:TabBarVMProtocol{
    var input: TabBarVMInput!
    private var bag:DisposeBag!
    
    private var coordinator: TabBarCoordinating!
    
    init(coordinator:TabBarCoordinating){
        input = TabBarVMInput()
        bag = DisposeBag()
        self.coordinator = coordinator
        
    }

}
