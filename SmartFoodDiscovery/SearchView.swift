import SwiftUI
import MapKit

struct SearchView: View {
    @StateObject private var searchManager = SearchManager()
    @StateObject private var locationManager = LocationManager()
    @StateObject private var aiManager = AIManager()
    @StateObject private var nutritionManager = NutritionManager()


    @State private var query: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                // 🗺 Current Map (auto centers on user location)
                Map(coordinateRegion: $locationManager.region)
                    .frame(height: 200)
                    .cornerRadius(12)
                    .padding(.horizontal)
                
                Divider().padding(.vertical, 5)
                
                // 🔍 Search bar for food
                HStack {
                    TextField("Search for food...", text: $query)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Go") {
                        searchManager.search(query: query, region: locationManager.region)
                        aiManager.analyzeQuery(query)
                        nutritionManager.fetchNutrition(for: query)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
                
                // 🤖 AI Insights
                if !aiManager.insights.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(aiManager.insights, id: \.self) { tag in
                            Text(tag)
                                .font(.subheadline)
                                .padding(6)
                                .background(Color.yellow.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                }
                if !nutritionManager.nutritionInfo.isEmpty {
                    Text(nutritionManager.nutritionInfo)
                        .font(.subheadline)
                        .padding(6)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }


                // 📋 Results
                List(searchManager.results, id: \.self) { item in
                    VStack(alignment: .leading) {
                        Text(item.name ?? "Unknown Place")
                            .font(.headline)
                        if let address = item.placemark.title {
                            Text(address)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Search 🍴")
        }
    }
}

