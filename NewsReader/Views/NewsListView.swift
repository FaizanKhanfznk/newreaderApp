//  Created by Faizan on 3/27/25.

import SwiftUI

struct NewsListView: View {
    @StateObject private var viewModel = NewsViewModel()
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.articles.isEmpty {
                    ProgressView()
                } else if let error = viewModel.error {
                    ErrorView(error: error, retryAction: {
                        Task { await viewModel.refresh() }
                    })
                } else {
                    List {
                        ForEach(appState.selectedCategories, id: \.self) { category in
                            Section(header: Text(category.displayName)) {
                                if viewModel.isLoading {
                                    ProgressView()
                                } else {
                                    ForEach(viewModel.articles) { article in
                                        NavigationLink {
                                            NewsDetailView(article: article)
                                        } label: {
                                            NewsRow(article: article)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("News Reader")
            .refreshable {
                await viewModel.refresh()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SearchView()
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }
        }
        .task {
            await viewModel.fetchNews()
        }
    }
}

struct NewsRow: View {
    let article: Article
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(article.title)
                .font(.headline)
                .lineLimit(2)
            
            HStack {
                Text(article.source.name)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if let date = article.publishedAt {
                    Text(date, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct ErrorView: View {
    let error: Error
    let retryAction: () -> Void
    
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.red)
            Text("Error loading news")
                .font(.title2)
            Text(error.localizedDescription)
                .font(.footnote)
                .multilineTextAlignment(.center)
                .padding()
            
            Button("Retry", action: retryAction)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
