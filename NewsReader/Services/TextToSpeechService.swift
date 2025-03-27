//  NewsReader
//  Created by Zigron on 3/27/25.

import AVFoundation

class TextToSpeechService:ObservableObject {
    
    private let synthesizer = AVSpeechSynthesizer()
    private var utterance: AVSpeechUtterance?
    
    func speak(text: String) {
        stopSpeaking()
        
        utterance = AVSpeechUtterance(string: text)
        utterance?.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance?.rate = AVSpeechUtteranceDefaultSpeechRate * 0.5
        
        synthesizer.speak(utterance!)
    }
    
    func stopSpeaking() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }
    
    func toggleSpeaking(text: String) {
        if synthesizer.isSpeaking {
            stopSpeaking()
        } else {
            speak(text: text)
        }
    }
}
