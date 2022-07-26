//
//  HomeViewModel.swift
//  2Grand
//
//  Created by Amin on 24/07/2022.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

protocol HomeInput{
    var onScreenAppeared:PublishSubject<Void>{get}
    var configureCell:PublishSubject<(cell:HomeCell,indexPath:IndexPath)>{get}
    var onPaginate:PublishSubject<Void>{get}
    var onSelect:PublishSubject<IndexPath>{get}
}

struct HomeVMInput:HomeInput{
    var onSelect: PublishSubject<IndexPath>
    var onPaginate: PublishSubject<Void>
    var configureCell: PublishSubject<(cell:HomeCell,indexPath:IndexPath)>
    var onScreenAppeared: PublishSubject<Void>
    
    init(){
        configureCell = PublishSubject()
        onScreenAppeared = PublishSubject<Void>()
        onPaginate = PublishSubject()
        onSelect = PublishSubject()
    }
}

protocol HomeOutput{
    var onFinishFetchingNews : Driver<[Article]>{get}
    var showProgress: Driver<Void>{get}
    var hideProgress: Driver<Void>{get}
    var showError: Driver<String>{get}
    var modelCount: Int {get}
}
struct HomeVMOutput:HomeOutput{
    var showError: Driver<String>
    var showProgress: Driver<Void>
    var hideProgress: Driver<Void>
    
    var modelCount: Int
    var onFinishFetchingNews: Driver<[Article]>
    
    fileprivate var newsObsRelay:BehaviorRelay<[Article]>
    fileprivate var showProgressSubject:PublishSubject<Void>
    fileprivate var hideProgressSubject:PublishSubject<Void>
    fileprivate var showErrorSubject: PublishSubject<String>
    
    init(){
        modelCount = 0
        newsObsRelay = BehaviorRelay(value: [])
        onFinishFetchingNews = newsObsRelay.asDriver(onErrorJustReturn: [])
        
        hideProgressSubject = PublishSubject()
        showProgressSubject = PublishSubject()
        showErrorSubject = PublishSubject()
        
        hideProgress = hideProgressSubject.asDriver(onErrorJustReturn: ())
        showProgress = showProgressSubject.asDriver(onErrorJustReturn: ())
        showError = showErrorSubject.asDriver(onErrorJustReturn: "")
    }
    
}

protocol HomeVMProtocol{
    var input:HomeVMInput! {get}
    var output:HomeVMOutput! {get}
}
class HomeViewModel:HomeVMProtocol{
    var input: HomeVMInput!
    var output: HomeVMOutput!
    
    private var isPaginating:Bool = false
    private var bag:DisposeBag!
    private var coordinator:HomeCoordinating!
    private var usecase: HomeUseCaseProtocol!
    
    init(coordinator:HomeCoordinating,usecase:HomeUseCaseProtocol){
        self.coordinator = coordinator
        self.usecase = usecase
        bag = DisposeBag()
        input = HomeVMInput()
        output = HomeVMOutput()
        bind()
    }
    
    private func bind(){
        input.onScreenAppeared.bind{ [weak self] _ in
            guard let self = self else {return}
            self.fetchNews(paging: false)
        }.disposed(by: bag)
        
        input.configureCell.bind{ [weak self] cell,indexPath in
            guard let self = self else {return}
            let index = indexPath.item
            let model = self.output.newsObsRelay.value[index]
            cell.configure(model: model)
            
        }.disposed(by: bag)
        
        input.onPaginate.bind{ [weak self] _ in
            guard let self = self else {return}
            self.isPaginating = !self.isPaginating
            if self.isPaginating == false {return}
            self.fetchNews(paging: true)
        }.disposed(by: bag)
        
        input.onSelect.bind{ [weak self] indexPath in
            guard let self = self else {return}
            let model = self.output.newsObsRelay.value[indexPath.item]
            self.coordinator.navigateToDetails(withModel: model)
        }.disposed(by: bag)
    }
    private func fetchNews(paging:Bool){

        self.output.showProgressSubject.onNext(())
        self.usecase.fetchNews(paginating: paging) { [weak self] articles in
            
            guard let self = self else {return}
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.output.hideProgressSubject.onNext(())
            }
            
            self.output.modelCount = articles.count + self.output.modelCount
            let all = self.output.newsObsRelay.value + articles
            self.output.newsObsRelay.accept(all)
            self.isPaginating = false
        } failure: { msg in
            self.output.showErrorSubject.onNext(msg)
            self.output.newsObsRelay.accept([])
            self.isPaginating = false
        }
        

    }
}
