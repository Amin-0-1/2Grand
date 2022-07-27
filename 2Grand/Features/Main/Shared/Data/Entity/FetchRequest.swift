//
//  HomeFetchRequest.swift
//  2Grand
//
//  Created by Amin on 26/07/2022.
//

import Foundation

struct FetchRequest:Codable{
    var page: Int = 1
    var sources: Source = .CNN
    var language:Language = .en
    var pageSize:Int = 10
    var apiKey:String = NetworkConfig.shared.API_KEY
}

enum Language:String,Codable{
    case ar
    case en
    case fr
}

enum Source:String,Codable{
    case CNN = "cnn"
    case Jazera = "al-jazeera-english"
    case Associated = "associated-press"
}
