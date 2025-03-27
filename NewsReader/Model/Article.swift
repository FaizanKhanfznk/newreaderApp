//  NewsReader
//  Created by Faizan on 3/27/25.

import SwiftUI

struct Article: Identifiable, Codable, Equatable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: Date?
    let content: String?
    let id: String?
    var category: String?
    
    static var placeholderArticles: [Article] {
        [
            Article(
                source: Source(id: nil, name: "Example News"),
                author: "John Doe",
                title: "Sample News Article",
                description: "This is a sample news article description that would appear in the list view.",
                url: "https://example.com",
                urlToImage: "https://via.placeholder.com/150",
                publishedAt: Date(),
                content: "This is the full content of the sample news article.", category: "News", id: "1"
            )
        ]
    }
    
    init(source: Source, author: String?, title: String, description: String?,
             url: String?, urlToImage: String?, publishedAt: Date?,
         content: String?, category: String?,id:String?) {
            self.source = source
            self.author = author
            self.title = title
            self.description = description
            self.url = url
            self.urlToImage = urlToImage
            self.publishedAt = publishedAt
            self.content = content
            self.category = category
            self.id = id
        }
}

struct Source: Codable, Equatable {
    let id: String?
    let name: String
}
