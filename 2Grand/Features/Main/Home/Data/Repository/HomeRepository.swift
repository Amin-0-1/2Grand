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
                guard let allNews = try? JSONDecoder().decode(AllNewsResponse.self, from: response.data) else {
                    fatalError("unable to decode")
                }
                completion(.success(allNews))
            case .failure(let error):
                print(error)
            }
        }
    }
}
