//
//  ResumeAnalyzerView.swift
//  AIPoweredResumeAnalyzer
//
//  Created by Sailesh Raturi on 21/07/25.
//

import SwiftUI
import Combine

struct ResumeAnalyzerView: View {
    
    @State private var resumeText: String = ""
    @State private var fileName: String = ""
    @State var JobRole: String = ""
 //   private var cancellables: Set<AnyCancellable> = .init()
    @EnvironmentObject var viewModel: ResumeAnalyzerViewModel
 //   @StateObject var viewModel = ResumeAnalyzerViewModel()
    
    var body: some View {
        VStack {
            TextField("Job Role", text: $JobRole)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            ResumeUploadView(resumeText: $resumeText, fileName: $fileName)//, viewModel: viewModel)

            
            Button("Analyze Resume"){
                viewModel.analyze(role: "developer", resumeText: resumeText)
                
            }
            .disabled(viewModel.isLoading)
            .padding()
            .background(Color.green.opacity(0.2))
            .cornerRadius(10)
            
            
            if viewModel.isLoading {
                ProgressView("Analyzing...")
            }else if !viewModel.analysisResult.isEmpty {
                ScrollView {
                    Text(viewModel.analysisResult)
                        .padding()
                }
                .frame(height: 300)
            }else if let error = viewModel.errorMessage{
                Text("Error \(error)")
                    .foregroundColor(.red)
            }
        }.padding()
    }
    
//    mutating func subscribeToViewModel() {
//        
//        viewModel.$analysisResult
//            .dropFirst()
//            .sink{ result in
//                self.resumeText = ""
//                
//            }
//            .store(in: &cancellables)
//    }
}

#Preview {
    ResumeAnalyzerView()
}
