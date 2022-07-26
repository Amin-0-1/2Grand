//
//  NetworkConfig.swift
//  2Grand
//
//  Created by Amin on 26/07/2022.
//

import Foundation

class NetworkConfig{
    static var shared:NetworkConfig = NetworkConfig()
    private init(){}
    
    let BASE_URL = "https://newsapi.org/v2/"
    let API_KEY = "de0932191b6944cf8b77d4a4de376a53"
    
}


