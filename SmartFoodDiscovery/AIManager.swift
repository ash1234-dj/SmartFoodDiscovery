//
//  AIManager.swift
//  SmartFoodDiscovery
//
//  Created by Ashfaq ahmed on 10/09/25.
//

import Foundation
import Combine 

final class AIManager: ObservableObject{
    @Published var insights: [String] = []
    func analyzeQuery(_ query: String) {
        self.insights = [
            "⭐Most Popular ",
            "🥦Healthier Alternatives ",
            "🪙Best value for money"
        ]
    }
}
