//
//  AllNewsResponse.swift
//  2Grand
//
//  Created by Amin on 26/07/2022.
//

import Foundation



import Foundation

struct AllNewsResponse: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]?
}

struct Article: Codable {
    
    let author: String?
    let title, articleDescription: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt ,content
    }
}
