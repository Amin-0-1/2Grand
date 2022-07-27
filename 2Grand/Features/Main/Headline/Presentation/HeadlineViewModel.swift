//
//  HeadlineViewModel.swift
//  2Grand
//
//  Created by Amin on 26/07/2022.
//

import Foundation
import RxSwift
import RxCocoa
protocol HeadlineInput{
    var onScreenAppeared:PublishSubject<Void>{get}
    var configureCell:PublishSubject<(cell:HeadlineCell,indexPath:IndexPath)>{get}
    var onPaginate:PublishSubject<Void>{get}
    var onSelect:PublishSubject<IndexPath>{get}
}
struct HeadlineVMInput:HeadlineInput{
    var onSelect: PublishSubject<IndexPath>
    
    var onPaginate: PublishSubject<Void>
    
    var configureCell: PublishSubject<(cell: HeadlineCell, indexPath: IndexPath)>
    
    var onScreenAppeared: PublishSubject<Void>
    init(){
        configureCell = PublishSubject()
        onScreenAppeared = PublishSubject()
        onPaginate = PublishSubject()
        onSelect = PublishSubject()
    }
    
}
protocol HeadlineOutput{
    var modelCount:Int {get}
    var newsObs:Driver<[Article]>{get}
    var showProgress: Driver<Void>{get}
    var hideProgress: Driver<Void>{get}
    var showError: Driver<String>{get}
    var onFinishFetchingNews : Driver<[Article]>{get}
}
struct HeadlineVMOutput:HeadlineOutput{
    var onFinishFetchingNews: Driver<[Article]>
    var showProgress: Driver<Void>
    var hideProgress: Driver<Void>
    var showError: Driver<String>
    
    var newsObs: Driver<[Article]>
    var modelCount: Int
    
    
    fileprivate var newsRelay:BehaviorRelay<[Article]>
    fileprivate var showProgressSubject:PublishSubject<Void>
    fileprivate var hideProgressSubject:PublishSubject<Void>
    fileprivate var showErrorSubject: PublishSubject<String>
    init(){
        modelCount = 0
        newsRelay = BehaviorRelay(value: [])
        newsObs = newsRelay.asDriver(onErrorJustReturn: [])
        
        hideProgressSubject = PublishSubject()
        showProgressSubject = PublishSubject()
        showErrorSubject = PublishSubject()
        
        hideProgress = hideProgressSubject.asDriver(onErrorJustReturn: ())
        showProgress = showProgressSubject.asDriver(onErrorJustReturn: ())
        showError = showErrorSubject.asDriver(onErrorJustReturn: "")
        
        onFinishFetchingNews = newsRelay.asDriver(onErrorJustReturn: [])
    }
}
protocol HeadlineVMProtocol{
    var input:HeadlineVMInput! {get}
    var output:HeadlineVMOutput! {get}
}
class HeadlineViewModel:HeadlineVMProtocol{
    var output: HeadlineVMOutput!
    var input: HeadlineVMInput!
    
    private var isPaginating:Bool = false
    private var coordinator:HeadlineCoordinating!
    private var bag:DisposeBag!
    private var useCase: HeadLineUseCaseProtocol!
    init(coordinator:HeadlineCoordinating,usecase:HeadLineUseCaseProtocol){
        bag = DisposeBag()
        self.useCase = usecase
        input = HeadlineVMInput()
        output = HeadlineVMOutput()
        self.coordinator = coordinator
        bind()
    }
    
    private func bind(){
        input.onScreenAppeared.bind{ [weak self] _ in
            guard let self = self else {return}
            self.fetchHeadlineNews(paging: false)

        }.disposed(by: bag)
        
        input.configureCell.bind{ [weak self] cell,indexpath in
            guard let self = self else {return}
            let index = indexpath.item
            let model = self.output.newsRelay.value[index]
            cell.configure(model: model)
        }.disposed(by: bag)
        
        input.onPaginate.bind{ [weak self] _ in
            guard let self = self else {return}
            self.isPaginating = !self.isPaginating
            if self.isPaginating == false {return}
            self.fetchHeadlineNews(paging: true)
        }.disposed(by: bag)
        
        input.onSelect.bind{ [weak self] indexPath in
            guard let self = self else {return}
            let model = self.output.newsRelay.value[indexPath.item]
            self.coordinator.navigateToDetails(withModel: model)
        }.disposed(by: bag)
        
    }
    private func fetchHeadlineNews(paging:Bool){
        
        self.output.showProgressSubject.onNext(())
        self.useCase.fetchNews(paginating: paging) { [weak self] articles in
            
            guard let self = self else {return}
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.output.hideProgressSubject.onNext(())
            }
            
            self.output.modelCount = articles.count + self.output.modelCount
            let all = self.output.newsRelay.value + articles
            self.output.newsRelay.accept(all)
            self.isPaginating = false
            
        } failure: { msg in
            self.output.showErrorSubject.onNext(msg)
            self.output.newsRelay.accept([])
            self.isPaginating = false
        }
    }
    
    
}
