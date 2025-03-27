
//  Created by Faizan on 3/27/25.

import Foundation
import UIKit
import Combine

//MARK: Observable object to check the observance with any change get occured.

class TextDetectionViewModel: ObservableObject {
    
    @Published var detectedText: String = ""
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var showArticleCreation: Bool = false
    
    private let textDetectionService = TextDetectionService()
    
    func detectText(in image: UIImage) {
        isLoading = true
        detectedText = ""
        
        //MARK: to detect the text from article
        textDetectionService.detectText(in: image) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let text):
                    self?.detectedText = text
                case .failure(let error):
                    self?.error = error
                }
            }
        }
    }
    
    func createArticle(title: String, source: String) -> Article {
          let now = Date()
          return Article(
              source: Source(id: nil, name: source),
              author: nil,
              title: title,
              description: detectedText,
              url: nil,
              urlToImage: nil,
              publishedAt: now,
              content: detectedText,
              category: "scanned",
              id: UUID().uuidString
          )
      }
    
    func clearDetection() {
        detectedText = ""
        error = nil
    }
}
