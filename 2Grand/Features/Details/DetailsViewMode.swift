//
//  DetailsViewMode.swift
//  2Grand
//
//  Created by Amin on 26/07/2022.
//

import Foundation
import RxSwift
protocol DetailsInput{
    var dismiss:PublishSubject<Void>{get}
}
struct DetailsVMInput:DetailsInput{
    var dismiss: PublishSubject<Void>
    init(){
        dismiss = PublishSubject()
    }
}
protocol DetailsVMPrtotocol{
    var input:DetailsVMInput! {get}
}
class DetailsViewModel:DetailsVMPrtotocol{
    var input: DetailsVMInput!
    private var coordinator:DetailsCoordinating!
    private var bag:DisposeBag!
    init(coordintor:DetailsCoordinating){
        self.coordinator = coordintor
        bag = DisposeBag()
        input = DetailsVMInput()
        bind()
    }
    private func bind(){
        input.dismiss.bind{ [weak self] _ in
            guard let self = self else {return}
            self.coordinator.dismiss()
        }.disposed(by: bag)
    }
    
}
