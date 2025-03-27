
//  Created by Faizan on 3/27/25.

import SwiftUI

struct TextDetectionView: View {
    
    @StateObject private var viewModel = TextDetectionViewModel()
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var showingArticleForm = false
    @State private var articleTitle = ""
    @State private var articleSource = "Scanned Document"
    
    var body: some View {
        NavigationStack {
            VStack {
                if let image = inputImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 300)
                } else {
                    Image(systemName: "newspaper")
                        .font(.system(size: 100))
                        .foregroundColor(.secondary)
                        .padding()
                }
                
                if viewModel.isLoading {
                    ProgressView("Detecting text...")
                        .padding()
                } else if !viewModel.detectedText.isEmpty {
                    ScrollView {
                        Text(viewModel.detectedText)
                            .padding()
                    }
                    .frame(maxHeight: 200)
                    .background(Color(.systemBackground))
                    .cornerRadius(8)
                    .shadow(radius: 2)
                    .padding()
                }
                
                Spacer()
                
                Button(action: {
                    showingImagePicker = true
                }) {
                    Text(inputImage == nil ? "Select Image" : "Different Image")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding()
                
                if !viewModel.detectedText.isEmpty {
                    Button("Create Article") {
                        showingArticleForm = true
                    }
                    .buttonStyle(.bordered)
                }
            }
            .navigationTitle("Text Detection")
            .toolbar {
                if !viewModel.detectedText.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Clear") {
                            viewModel.clearDetection()
                            inputImage = nil
                        }
                    }
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .onChange(of: inputImage) { newImage in
                if let newImage = newImage {
                    viewModel.detectText(in: newImage)
                }
            }
            .sheet(isPresented: $showingArticleForm) {
                NavigationStack {
                    Form {
                        TextField("Article Title", text: $articleTitle)
                        TextField("Source", text: $articleSource)
                        
                        Section {
                            Button("Save Article") {
                                let article = viewModel.createArticle(
                                    title: articleTitle,
                                    source: articleSource
                                )
                                //MARK: save to core data
                                showingArticleForm = false
                            }
                            .disabled(articleTitle.isEmpty)
                        }
                    }
                    .navigationTitle("Create Article")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Cancel") {
                                showingArticleForm = false
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.dismiss()
        }
    }
}
