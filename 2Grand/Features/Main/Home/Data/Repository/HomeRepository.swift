//
//  HomeRepository.swift
//  2Grand
//
//  Created by Amin on 26/07/2022.
//

import Foundation
import Moya

class HomeRepository:HomeRepoInterface{
    
    private var remote:MoyaProvider<HomeTarget>!
    init(remote:MoyaProvider<HomeTarget>){
        self.remote = remote
    }
    
    func fetchNews(request: HomeFetchRequest,completion: @escaping (Result<AllNewsResponse, HomeError>) -> Void) {
        remote.request(.fetch(request: request)) { result in
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
                
                
            case .failure(_):
                completion(.failure(.Internet))
                
            }
        }
    }
}
