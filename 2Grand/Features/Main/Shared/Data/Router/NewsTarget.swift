//
//  HomeTarget.swift
//  2Grand
//
//  Created by Amin on 26/07/2022.
//

import Foundation
import Moya

enum NewsTarget{
    case fetch(request:FetchRequest)
    case fetchHeadlines(request:FetchRequest)
}

extension NewsTarget:TargetType{
    var baseURL: URL {
        return URL(string: NetworkConfig.shared.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .fetch:
            return HomeNetworkPath.AllNews.rawValue
        case .fetchHeadlines:
            return HomeNetworkPath.Headlines.rawValue
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .fetch(let request):
            return .requestParameters(parameters: request.dictionary ?? [:], encoding: URLEncoding.queryString)
        case .fetchHeadlines(request: let request):
            return .requestParameters(parameters: request.dictionary ?? [:], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
