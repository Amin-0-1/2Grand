//
//  RepoInterface.swift
//  2Grand
//
//  Created by Amin on 26/07/2022.
//

import Foundation

protocol HomeRepoInterface{
    func fetchNews(request:HomeFetchRequest,completion:@escaping(Result<AllNewsResponse,HomeError>)->Void)
}
