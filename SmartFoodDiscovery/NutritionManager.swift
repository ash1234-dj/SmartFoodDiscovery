//
//  NutritionManager.swift
//  SmartFoodDiscovery
//
//  Created by Ashfaq ahmed on 10/09/25.
//

import Foundation
import Combine

struct NutritionSummary: Equatable {
    var calories: Double?
    var protein: Double?
    var fat: Double?
    var carbs: Double?
    
    var formatted: String {
        let calStr = calories.map { String(format: "Calories: %.0f kcal", $0) }
        let proteinStr = protein.map { String(format: "Protein: %.1f g", $0) }
        let fatStr = fat.map { String(format: "Fat: %.1f g", $0) }
        let carbsStr = carbs.map { String(format: "Carbs: %.1f g", $0) }
        
        let parts = [calStr, proteinStr, fatStr, carbsStr].compactMap { $0 }
        return parts.isEmpty ? "" : parts.joined(separator: " • ")
    }
}

final class NutritionManager: ObservableObject {
    // Keep existing published string for current UI
    @Published var nutritionInfo: String = ""
    // Add a structured model for future use
    @Published var nutrition: NutritionSummary = .init()
    
    private let apiKey = "06be48fd6fcc439bada35a435aaf3ded"
    
    func fetchNutrition(for dish: String) {
        guard let encoded = dish.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.spoonacular.com/recipes/complexSearch?query=\(encoded)&addRecipeNutrition=true&number=1&apiKey=\(apiKey)") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("API Error:", error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            // Parse minimally with JSONSerialization to match your current approach
            guard
                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let results = json["results"] as? [[String: Any]],
                let first = results.first,
                let nutrition = first["nutrition"] as? [String: Any],
                let nutrients = nutrition["nutrients"] as? [[String: Any]]
            else {
                DispatchQueue.main.async {
                    self.nutritionInfo = ""
                    self.nutrition = .init()
                }
                return
            }
            
            func value(for name: String) -> Double? {
                guard let item = nutrients.first(where: { ($0["name"] as? String)?.lowercased() == name.lowercased() }) else {
                    return nil
                }
                // Spoonacular returns numeric amounts; be defensive in case it’s a number boxed as Any
                if let amount = item["amount"] as? Double {
                    return amount
                } else if let amountNum = item["amount"] as? NSNumber {
                    return amountNum.doubleValue
                } else if let amountStr = item["amount"] as? String, let val = Double(amountStr) {
                    return val
                }
                return nil
            }
            
            let summary = NutritionSummary(
                calories: value(for: "Calories"),
                protein: value(for: "Protein"),
                fat: value(for: "Fat"),
                carbs: value(for: "Carbohydrates")
            )
            
            DispatchQueue.main.async {
                self.nutrition = summary
                self.nutritionInfo = summary.formatted
            }
        }.resume()
    }
}
