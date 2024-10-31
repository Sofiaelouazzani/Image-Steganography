import SwiftUI

struct UploadedImage: Identifiable {
    let id = UUID()
    let name: String
    let image: Image
}

struct MainView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                } .overlay(Rectangle().fill(Color.black).frame(height: 20), alignment: .bottom)
            
            EncryptView()
                .tabItem {
                    Label("Encrypt", systemImage: "lock.fill")
                } .overlay(Rectangle().fill(Color.red).frame(height: 20), alignment: .bottom)
            
            DecryptView()
                .tabItem {
                    Label("Decrypt", systemImage: "key.fill")
                } .overlay(Rectangle().fill(Color.red).frame(height: 20), alignment: .bottom)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                } .overlay(Rectangle().fill(Color.black).frame(height: 20), alignment: .bottom)
        }
        .modifier(TabBarModifier()) // Use your custom TabBarModifier for colors
    }
}
struct HomeView: View {
    @State private var uploadedImages: [UploadedImage] = [
        UploadedImage(name: "...", image: Image("vacation")),
        UploadedImage(name: "...", image: Image("family")),
        UploadedImage(name: "...", image: Image("nature"))
    ]
    var body: some View {
            NavigationView {
                ZStack {
                    // Background Image
                    Image("wolf") // Replace with your image name
                        .resizable()
                        .ignoresSafeArea() // Ensures the image covers the entire view
                        
                    
                    // Content with ScrollView
                    ScrollView {
                        Text("Uploaded Images")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        VStack(spacing: 20) {
                            ForEach(uploadedImages) { uploadedImage in
                                HStack {
                                    uploadedImage.image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 10, height: 70) // Fixed size for each image
                                        .clipped()
                                        .cornerRadius(8)
                                    
                                    Text(uploadedImage.name)
                                        .font(.headline)
                                        .padding(.leading, 10)
                                }
                                .frame(maxWidth: .infinity) // Expand to full width
                                .padding()
                                .background(Color.white) // Optional for readability
                                .cornerRadius(10)
                                .shadow(radius: 3)
                            }
                        }
                        .padding() // Adds padding around the content
                    }
                }
            }
        }
}

struct EncryptView: View {
    var body: some View {
        ZStack {
            // Background image
            Image("wolf") // Replace with the name of your image asset
                .resizable()
                .ignoresSafeArea()
            VStack {
                Text("Encrypt Screen")
                // Additional UI components for Encrypting an image
            }
            .padding()
        }
    }
}

struct DecryptView: View {
    var body: some View {
        ZStack {
            // Background image
            Image("wolf") // Replace with the name of your image asset
                .resizable()
                .ignoresSafeArea()
            VStack {
                Text("Decrypt Screen")
                // Additional UI components for Decrypting an image
            }
            .padding()
        }
    }
}

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Settings Screen")
            // Additional settings components
        }
        .padding()
    }
}

#Preview {
    MainView()
}



struct TabBarModifier: ViewModifier {
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black // Set tab bar background to white

        // Customize unselected and selected icon colors
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray  // Unselected icon color
        UITabBar.appearance().tintColor = UIColor.blue // Selected icon color (customize as needed)

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    func body(content: Content) -> some View {
        content
    }
}
