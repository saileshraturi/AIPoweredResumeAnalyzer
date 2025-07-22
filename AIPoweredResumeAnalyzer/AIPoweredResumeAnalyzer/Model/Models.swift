//
//  Models.swift
//  AIPoweredResumeAnalyzer
//
//  Created by Sailesh Raturi on 21/07/25.
//

import Foundation


//ai service - model to be used, request(role, text), temperature

struct openAIRequest: Codable {
    var model: String
    var messages: [openAIMessage]
    var temperature: Double
}

struct openAIMessage: Codable{
    let role: String
    let content: String
}

struct openAIResponse: Codable {
    struct choice : Codable{
        let message: openAIMessage
    }
    let choices: [choice]
}
