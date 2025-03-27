
//  Created by Faizan on 3/27/25.

import SwiftUI

struct NewsDetailView: View {
    
    let article: Article
    @StateObject private var ttsService = TextToSpeechService()
    @State private var isSpeaking = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let imageUrl = article.urlToImage {
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 200)
                    .clipped()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(article.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    HStack {
                        Text(article.source.name)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        if let date = article.publishedAt {
                            Text(date, style: .date)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Divider()
                    
                    if let description = article.description {
                        Text(description)
                            .font(.body)
                    }
                    
                    if let content = article.content {
                        Text(content)
                            .font(.body)
                            .padding(.top, 8)
                    }
                }
                .padding()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isSpeaking.toggle()
                    ttsService.toggleSpeaking(text: article.content ?? article.description ?? article.title)
                } label: {
                    Image(systemName: isSpeaking ? "speaker.wave.2.fill" : "speaker.wave.2")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            ttsService.stopSpeaking()
        }
    }
}
