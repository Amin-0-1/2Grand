//
//  HeadlineUsecase.swift
//  2Grand
//
//  Created by Amin on 27/07/2022.
//

import Foundation

protocol HeadLineUseCaseProtocol{
    func fetchNews(paginating:Bool,success: @escaping ([Article]) -> Void,failure: ((String)->Void)?)
}

class HeadlineUseCase:HeadLineUseCaseProtocol{
    
    private var page = 1
    private var repo:HeadlineRepoInterface!
    init(repo:HeadlineRepoInterface){
        self.repo = repo
    }
    
    func fetchNews(paginating: Bool, success: @escaping ([Article]) -> Void, failure: ((String) -> Void)?) {
        if paginating {
            page += 1
        }
        let request = FetchRequest(page: page,pageSize: 6)
        repo.fetchHeadLines(request: request) { result in
            switch result{
            case .failure(let error):
                failure?(error.description)
            case .success(let response):
                success(response.articles ?? [])
            }
        }
    }
    
}
