//  NewsReader
//  Created by Faizan on 3/27/25.

import Vision
import UIKit

//MARK: Services defined for detectig the text from image
class TextDetectionService {
    
    func detectText(in image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(.failure(TextDetectionError.invalidImage))
            return
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion(.failure(TextDetectionError.noTextFound))
                return
            }
            
            let recognizedStrings = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }
            
            let result = recognizedStrings.joined(separator: "\n")
            completion(.success(result))
        }
        
        request.recognitionLevel = .accurate
        
        do {
            try requestHandler.perform([request])
        } catch {
            completion(.failure(error))
        }
    }
}

enum TextDetectionError: Error {
    case invalidImage
    case noTextFound
}
