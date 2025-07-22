//
//  OpenAIService.swift
//  AIPoweredResumeAnalyzer
//
//  Created by Sailesh Raturi on 21/07/25.
//

import Foundation

class OpenAIService {
    
    private let APIkey = "Use your API key here"
    
    func analyzeResume(role: String, resumeText : String , completionHandler: @escaping (String?) -> Void){
        
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else{
            completionHandler(nil)
            return
        }
        
        let prompt = """
        You are an expert resume reviewer. Analyze the resume below for a job seeker applying as a \(role):

        \(resumeText)

        Respond with:
        1. Summary
        2. Strengths
        3. Weaknesses
        4. ATS-friendliness
        5. Score out of 10
        6. Suggestions
        7. 5 missing keywords for \(role)
        """
        
        let message = openAIMessage(role: role, content: prompt)
        
        let requestBody = openAIRequest(model: "gpt-4o-mini", messages: [message], temperature: 0.7)
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("Bearer \(APIkey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do{
            request.httpBody = try JSONEncoder().encode(requestBody)
        }catch{
            print("encoding error \(error)")
            completionHandler(nil)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else{
                print("no data returned \(String(describing: error?.localizedDescription))")
                completionHandler(nil)
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data),
               let dict = json as? [String: Any],
               let error = dict["error"] as? [String: Any],
               let message = error["message"] as? String {
                print("OpenAI error: \(message)")
                return
            }
            
            do{
                let decoded =  try JSONDecoder().decode(openAIResponse.self, from: data)
                let responseText = decoded.choices.first?.message.content
                print("resume analysis: \(String(describing: responseText))")
                completionHandler(responseText)
                
            }catch{
                print("decoding error \(error)")
                completionHandler(nil)
            }
            
            
        }.resume()
        
    }
}
