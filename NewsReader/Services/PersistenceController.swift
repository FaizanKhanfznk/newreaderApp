//
//  PersistenceController.swift
//  NewsReader
//  Created by Faizan on 3/27/25.

import CoreData
import Foundation

class PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CoreData")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func saveContext() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func saveArticles(_ articles: [Article]) async {
        await container.performBackgroundTask { context in
            for article in articles {
                let _ = ArticleEntity.from(article: article, in: context)
            }
            
            do {
                try context.save()
            } catch {
                print("Failed to save articles: \(error)")
            }
        }
    }
    
    func fetchSavedArticles() async -> [Article] {
        await withCheckedContinuation { continuation in
            container.performBackgroundTask { context in
                let request = ArticleEntity.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(keyPath: \ArticleEntity.publishedAt, ascending: false)]
                
                do {
                    let results = try context.fetch(request)
                    let articles = results.compactMap { $0.toArticle() }
                    continuation.resume(returning: articles)
                } catch {
                    print("Failed to fetch saved articles: \(error)")
                    continuation.resume(returning: [])
                }
            }
        }
    }
}

extension ArticleEntity {
    
    func toArticle() -> Article? {
        guard let title = title, let source = source else { return nil }
        
        return Article(
            source: Source(id: nil, name: source),
            author: author,
            title: title,
            description: articleDescription,
            url: url,
            urlToImage: urlToImage,
            publishedAt: publishedAt,
            content: content, category: category, id: nil
        )
    }
    
    static func from(article: Article, in context: NSManagedObjectContext) -> ArticleEntity {
          let entity = ArticleEntity(context: context)
            entity.id = article.id
          entity.title = article.title
          entity.source = article.source.name
          entity.author = article.author
          entity.articleDescription = article.description
          entity.url = article.url
          entity.urlToImage = article.urlToImage
          entity.publishedAt = article.publishedAt
          entity.content = article.content
          entity.category = article.category
          return entity
      }
}
