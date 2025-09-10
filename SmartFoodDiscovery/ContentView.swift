//
//  ContentView.swift
//  SmartFoodDiscovery
//
//  Created by Ashfaq ahmed on 08/09/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.circle.fill")
                    Text("Home")
                }
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass.circle")
                    Text("Search")
                }
            FavoritesView()
                .tabItem {
                    Image(systemName: "heart.circle")
                    Text("Favorites")
                }
        }
    }
}


struct HomeView: View {
    @State private var searchText = ""
    var body: some View{
        NavigationStack{
            VStack(spacing: 0){
                HStack{
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.black)
                        
                    TextField("Search for food items...", text: $searchText)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()
                ScrollView{
                    VStack(spacing: 35 ){
                        SmartSection(title: " 🍲 AI Powered Insights [ Apple Intelligence 📱] ",
                                     subtitle: " Most popular dishes near you ")
                        SmartSection(title: "🔥 Personalized + Local Trends",
                                     subtitle: "Trending this week in your area")
                        SmartSection(title: "🥗 Budget & Health Discovery",
                                     subtitle: "Best meals under ₹200 nearby")
                    }
                    .padding()
                }
                                     
                    Spacer()
                       
                    }
            
                
            }
        .navigationTitle("Smart Food Discovery 🍽")
            
        }
    }

struct SmartSection: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}



struct FavoritesView: View {
    var body: some View {
        Text("My Favorite Screen")
    }
}


#Preview{
    ContentView()
}
