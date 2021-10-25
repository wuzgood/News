//
//  News.swift
//  News
//
//  Created by Wuz Good on 22.10.2021.
//

import Foundation

struct API {
    static var URL = "https://newsapi.org/v2/everything?"
    static var key = "&apiKey=c55c07c0b81c498289123bc110f88a0c"
}

// MARK: - News
struct News: Codable {
    let status: String
    let totalResults: Int?
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let source: Source
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String?
}

struct NewsError: Codable {
    let status: String
    let code: String?
    let message: String?
}
