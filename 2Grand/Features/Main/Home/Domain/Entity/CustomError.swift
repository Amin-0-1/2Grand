//
//  HomeError.swift
//  2Grand
//
//  Created by Amin on 26/07/2022.
//

import Foundation

enum CustomError:Error,CustomStringConvertible{
    case OK
    case ServerError
    case TooMany
    case Internet
}

extension CustomError{
    var description: String{
        switch self {
        case .OK:
            return "An Error Occured try again later"
        case .ServerError:
            return "Internal server error, Please try again later"
        case .Internet:
            return "No Internet Connection, Please try again later..."
        case .TooMany:
            return "Too many requests, please try again later ..."
        }
    }
}
