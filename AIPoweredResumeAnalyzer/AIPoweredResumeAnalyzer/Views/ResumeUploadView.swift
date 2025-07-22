//
//  ResumeUploadView.swift
//  AIPoweredResumeAnalyzer
//
//  Created by Sailesh Raturi on 21/07/25.
//

import SwiftUI
import PDFKit
import UniformTypeIdentifiers

struct ResumeUploadView: View {
    @Binding var resumeText: String
    @Binding var fileName: String
    @State private var showFileImporter = false
    @EnvironmentObject var viewModel: ResumeAnalyzerViewModel
 //   @StateObject var viewModel: ResumeAnalyzerViewModel
    var body: some View {
        
        VStack(spacing : 16){
            Button(action: {
                showFileImporter = true
                viewModel.analysisResult = ""
            } ){
                Label("upload resume", systemImage: "doc.fill")
                    .frame(width: 300, height: 50)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            
            if !resumeText.isEmpty {
                Text("resume uplaoded: \(fileName)")
                    .font(.subheadline)
                    .foregroundStyle(.foreground)
            }
            if !resumeText.isEmpty && viewModel.analysisResult.isEmpty {
                ScrollView{
                    Text(resumeText)
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                }
                .frame(height: 300)
            }
            
            
        }
        .padding()
//        .fileImporter(
//            isPresented: $showFileImporter,
//            allowedContentTypes: [
//                .image, .pdf, .data, .plainText, .rtf,
//                .init(filenameExtension: "doc")!,
//                .init(filenameExtension: "docx")!
//            ]
//        ) { result in
//            handleFileImport(result: result)
//        }
        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [.pdf]
         //   allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let url):
             //   guard let url = url.first else { return }
                fileName = url.lastPathComponent
                resumeText = extractText(url: url)
                
            case .failure(let error):
                print("File selection error : \(error.localizedDescription)")
            }
        }
        
    }
    
    func handleFileImport(result : Result<URL, Error>){
        print("FileImprted\(result)")
        if let resultURL = try? result.get(){
            fileName = resultURL.lastPathComponent
            resumeText = extractText(url: resultURL)
        }
        
    }
    
    private func extractText(url : URL) -> String{
        guard url.startAccessingSecurityScopedResource() else {
            print("❌ Could not access file due to sandbox restrictions.")
            return ""
        }

        defer { url.stopAccessingSecurityScopedResource() }
        
        guard FileManager.default.fileExists(atPath: url.path) else {
            print("❌ File does not exist at path:", url.path)
            return "File not found."
        }
        guard let pdf = PDFDocument(url: url) else{
            print("failed to read PDF")
            return ""
        }
        var fullText = ""
        
        for i in 0..<pdf.pageCount{
            if let page = pdf.page(at: i),
                let pageText = page.string{
                fullText += pageText + "\n"
                }
        }
        
        return fullText.trimmingCharacters(in: .whitespacesAndNewlines)
        
    }
}

#Preview {
 //   ResumeUploadView(resumeText: "", fileName: "")
}
