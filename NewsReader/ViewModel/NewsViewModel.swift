//  NewsReader
//  Created by Faizan on 3/27/25.

import Foundation
import Combine

//MARK: Business logic of news view model
class NewsViewModel: ObservableObject {
    
    @Published var articles: [Article] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var selectedCategory: NewsCategory?
    @Published var selectedCountry = "us"

    private let newsService: NewsAPIServiceProtocol
    private let persistence: PersistenceController
    private var cancellables = Set<AnyCancellable>()
    
    init(newsService: NewsAPIServiceProtocol = NewsAPIService(),
         persistence: PersistenceController = .shared) {
        self.newsService = newsService
        self.persistence = persistence
    }

    func fetchNews(for category: NewsCategory? = nil) async {
        
        DispatchQueue.main.async {
            self.isLoading = true
            self.selectedCategory = category
        }
        
        do {
            let fetchedArticles = try await newsService.fetchTopHeadlines(category: category?.rawValue,country: selectedCountry)
            await MainActor.run {
                articles = fetchedArticles
                isLoading = false
            }
            await persistence.saveArticles(fetchedArticles)
        } catch {
            await MainActor.run {
                self.error = error
                isLoading = false
            }
            await loadCachedArticles()
        }
    }
    
    private func loadCachedArticles() async {
        let cachedArticles = await persistence.fetchSavedArticles()
        await MainActor.run {
            articles = cachedArticles
        }
    }
    
    func refresh() async {
        await fetchNews(for: selectedCategory)
    }
}

enum NewsCategory: String, CaseIterable, Codable, Identifiable {
    case general, business, entertainment, health, science, sports, technology
    
    var id: String { rawValue }
    var displayName: String { rawValue.capitalized }
    
    static var defaultCategories: [NewsCategory] {
        [.general, .technology, .business]
    }
}
