//
//  tabbar.swift
//  Image_steganography_by_sofiae
//
//  Created by Sofia Elouazzani on 2024-11-05.
//
import SwiftUI

struct tabbarView: View {
    var body: some View {
        TabView {
            hh()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            ss()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}

struct hh: View {
    var body: some View {
        NavigationView {
            Text("Home View")
                .font(.largeTitle)
                .navigationTitle("Home")
        }
    }
}

struct ss: View {
    var body: some View {
        NavigationView {
            Text("Settings View")
                .font(.largeTitle)
                .navigationTitle("Settings")
        }
    }
}

struct ProfileView: View {
    var body: some View {
        NavigationView {
            Text("Profile View")
                .font(.largeTitle)
                .navigationTitle("Profile")
        }
    }
}

struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            tabbarView()
        }
    }
}
#Preview {
    tabbarView()
}
