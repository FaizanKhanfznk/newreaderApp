
//  Created by Faizan on 3/27/25.

import SwiftUI

struct SearchView: View {
    
    @StateObject private var viewModel = SearchViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.searchResults.isEmpty {
                    if viewModel.searchText.isEmpty {
                        VStack {
                            Image(systemName: "magnifyingglass")
                                .font(.largeTitle)
                            Text("Search for news articles")
                                .font(.title2)
                        }
                        .foregroundColor(.secondary)
                    } else {
                        Text("No results found")
                            .foregroundColor(.secondary)
                    }
                } else {
                    List(viewModel.searchResults) { article in
                        NavigationLink {
                            NewsDetailView(article: article)
                        } label: {
                            NewsRow(article: article)
                        }
                    }
                }
            }
            .navigationTitle("Search")
            .searchable(text: $viewModel.searchText, prompt: "Search news...")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .onChange(of: viewModel.searchText) { newValue in
                if newValue.isEmpty {
                    viewModel.clearSearch()
                }
            }
        }
    }
}
