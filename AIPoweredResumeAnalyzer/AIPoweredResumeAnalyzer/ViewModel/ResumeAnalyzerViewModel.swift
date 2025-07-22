//
//  ResumeAnalyzerViewModel.swift
//  AIPoweredResumeAnalyzer
//
//  Created by Sailesh Raturi on 21/07/25.
//

import Foundation


class ResumeAnalyzerViewModel : ObservableObject {
    
    @Published var analysisResult: String = ""
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    private let openAIService = OpenAIService()
    
    func analyze(role: String, resumeText: String)  {
        isLoading = true
        errorMessage = nil
        
//        DispatchQueue.main.async {
//            self.isLoading = false
//            self.analysisResult = "This is a sample analysis result"
//            
//        }
  
        openAIService.analyzeResume(role: role, resumeText: resumeText) { [weak  self] (result) in
            DispatchQueue.main.async {
                if let result = result {
                    self?.isLoading = false
                    self?.analysisResult = result
                }else{
                    self?.isLoading = true
                    self?.errorMessage = "Failed to get analysis from OpenAI"
                }
                
            }
            
        }
        
    }
}
