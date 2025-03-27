//  NewsReader
//  Created by Zigron on 3/27/25.


import Foundation
import Combine
//MARK: Blue print method for news api service
protocol NewsAPIServiceProtocol {
    func fetchTopHeadlines(category: String?, country: String) async throws -> [Article]
    func searchNews(query: String) async throws -> [Article]
}

class NewsAPIService: NewsAPIServiceProtocol {
    //MARK: we can encode these keys in keygen to make it secure call
    private let apiKey = "106f471e0c4d45c49ac96161a15d8bf7"
    private let baseURL = "https://newsapi.org/v2"
    
    func fetchTopHeadlines(category: String?, country: String = "us") async throws -> [Article] {
        var components = URLComponents(string: "\(baseURL)/top-headlines")!
        var queryItems = [URLQueryItem(name: "country", value: country),
                          URLQueryItem(name: "apiKey", value: apiKey)]
        
        if let category = category {
            queryItems.append(URLQueryItem(name: "category", value: category))
        }
        
        components.queryItems = queryItems
        
        let (data, response) = try await URLSession.shared.data(from: components.url!)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NewsAPIError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let newsResponse = try decoder.decode(NewsAPIResponse.self, from: data)
        
        return newsResponse.articles
    }
    
    func searchNews(query: String) async throws -> [Article] {
        var components = URLComponents(string: "\(baseURL)/everything")!
        let queryItems = [URLQueryItem(name: "q", value: query),
                          URLQueryItem(name: "sortBy", value: "publishedAt"),
                          URLQueryItem(name: "apiKey", value: apiKey)]
        
        components.queryItems = queryItems
        
        let (data, response) = try await URLSession.shared.data(from: components.url!)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NewsAPIError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let newsResponse = try decoder.decode(NewsAPIResponse.self, from: data)
        
        return newsResponse.articles
    }
}

enum NewsAPIError: Error {
    case invalidResponse
    case invalidURL
}

struct NewsAPIResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}
