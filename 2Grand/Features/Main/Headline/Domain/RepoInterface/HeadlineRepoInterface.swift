//
//  HeadlineRepoInterface.swift
//  2Grand
//
//  Created by Amin on 27/07/2022.
//

import Foundation

protocol HeadlineRepoInterface{
    func fetchHeadLines(request:FetchRequest,completion:@escaping(Result<AllNewsResponse,CustomError>)->Void)
}
