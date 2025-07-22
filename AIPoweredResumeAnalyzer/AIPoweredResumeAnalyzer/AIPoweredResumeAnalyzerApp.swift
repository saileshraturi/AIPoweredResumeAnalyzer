//
//  AIPoweredResumeAnalyzerApp.swift
//  AIPoweredResumeAnalyzer
//
//  Created by Sailesh Raturi on 21/07/25.
//

import SwiftUI

@main
struct AIPoweredResumeAnalyzerApp: App {
    
    @StateObject var viewModel = ResumeAnalyzerViewModel()
    
    var body: some Scene {
        WindowGroup {
            ResumeAnalyzerView()
                .environmentObject(viewModel)
        }
    }
}
