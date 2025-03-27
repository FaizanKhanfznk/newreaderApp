//
//  SearchViewModel.swift
//  NewsReader
//  Created by Faizan on 3/27/25.

import Foundation
import Combine

//MARK: View model of search epic
class SearchViewModel: ObservableObject {
    
    @Published var searchText = ""
    @Published var searchResults: [Article] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let newsService: NewsAPIServiceProtocol
    private var searchCancellable: AnyCancellable?
    
    init(newsService: NewsAPIServiceProtocol = NewsAPIService()) {
        self.newsService = newsService
        
        //MARK: Pass by subject 
        searchCancellable = $searchText
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
    }
    
    private func performSearch(query: String) {
        isLoading = true
        
        Task {
            do {
                let results = try await newsService.searchNews(query: query)
                await MainActor.run {
                    searchResults = results
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = error
                    isLoading = false
                    searchResults = []
                }
            }
        }
    }
    
    func clearSearch() {
        searchText = ""
        searchResults = []
    }
}
