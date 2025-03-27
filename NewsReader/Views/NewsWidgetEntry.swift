//  Created by Faizan on 3/27/25.

import WidgetKit
import SwiftUI

struct NewsWidgetEntry: TimelineEntry {
    let date: Date
    let articles: [Article]
}

struct NewsWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> NewsWidgetEntry {
        NewsWidgetEntry(date: Date(), articles: Article.placeholderArticles)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (NewsWidgetEntry) -> Void) {
        let entry = NewsWidgetEntry(date: Date(), articles: Article.placeholderArticles)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<NewsWidgetEntry>) -> Void) {
        Task {
            do {
                let service = NewsAPIService()
                let articles = try await service.fetchTopHeadlines(category: nil)
                let entry = NewsWidgetEntry(date: Date(), articles: Array(articles.prefix(3)))
                let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60 * 60)))
                completion(timeline)
            } catch {
                let entry = NewsWidgetEntry(date: Date(), articles: Article.placeholderArticles)
                let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60 * 15)))
                completion(timeline)
            }
        }
    }
}

struct NewsWidgetEntryView: View {
    var entry: NewsWidgetProvider.Entry
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(entry.articles) { article in
                VStack(alignment: .leading) {
                    Text(article.title)
                        .font(.system(size: 12, weight: .semibold))
                        .lineLimit(2)
                    Text(article.source.name)
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 4)
            }
        }
        .padding()
    }
}

struct NewsWidget: Widget {
    let kind: String = "NewsWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: NewsWidgetProvider()) { entry in
            NewsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Latest News")
        .description("Shows the latest news headlines")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
