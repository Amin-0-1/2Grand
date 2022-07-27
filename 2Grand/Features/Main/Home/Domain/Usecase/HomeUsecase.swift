//
//  HomeUsecase.swift
//  2Grand
//
//  Created by Amin on 26/07/2022.
//

import Foundation

protocol HomeUseCaseProtocol{
    func fetchNews(paginating:Bool,success: @escaping ([Article]) -> Void,failure: ((String)->Void)?)
}

class HomeUseCase:HomeUseCaseProtocol{
    

    private var repo : HomeRepoInterface!
    private var page = 1
    init(repo:HomeRepoInterface){
        self.repo = repo
    }
    
    func fetchNews(paginating:Bool = false,success: @escaping ([Article]) -> Void, failure: ((String) -> Void)? = nil) {
        
        if paginating {page += 1}
        
        let req = FetchRequest(page: page)
        repo.fetchNews(request: req) { result in
            switch result{
            case .failure(let error):
                switch error{
                case .OK:
                    failure?(CustomError.OK.description)
                case .Internet:
                    failure?(CustomError.Internet.description)
                case .ServerError:
                    failure?(CustomError.ServerError.description)
                case .TooMany:
                    failure?(CustomError.TooMany.description)
                }
                print(error.localizedDescription)
            case .success(let response):
                success(response.articles ?? [])
            }
            
        }
        
    }
    
}
