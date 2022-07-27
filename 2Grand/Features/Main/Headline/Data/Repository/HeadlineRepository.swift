//
//  HeadlineRepository.swift
//  2Grand
//
//  Created by Amin on 27/07/2022.
//

import Foundation
import Moya
class HeadlineRepository:HeadlineRepoInterface{

    private var remote:MoyaProvider<NewsTarget>!
    init(remote:MoyaProvider<NewsTarget>){
        self.remote = remote
    }
    
    func fetchHeadLines(request: FetchRequest, completion: @escaping (Result<AllNewsResponse, CustomError>) -> Void) {
        
        remote.request(.fetchHeadlines(request: request)) { result in
            switch result{
            case .success(let response):
                if response.statusCode == 200{
                    guard let allNews = try? JSONDecoder().decode(AllNewsResponse.self, from: response.data) else {
                        fatalError("unable to decode")
                    }
                    completion(.success(allNews))
                }else if response.statusCode == 429{
                    completion(.failure(.TooMany))
                }else if response.statusCode == 500{
                    completion(.failure(.ServerError))
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(.Internet))
            }
        }
    }
    
    
}
