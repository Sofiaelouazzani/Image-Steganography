import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct ImageSteganographyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                if authViewModel.isSignedIn {
                    MainView()
                        .environmentObject(authViewModel)
                } else {
                    LoginView()
                        .environmentObject(authViewModel)
                }
            }
        }
    }
}

class AuthViewModel: ObservableObject {
    @Published var isSignedIn = false
    @Published var errorMessage: String?

    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
            } else {
                self?.isSignedIn = true
            }
        }
    }
    
    func signOut() {
            do {
                try Auth.auth().signOut()
                isSignedIn = false
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    
}

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false

    var body: some View {
        ZStack {
            Image("wolf")
                .resizable()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    Image(systemName: "lock.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.blue)
                        .padding(.bottom, 20)
                    
                    Text("Welcome to ")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white) +
                    Text("Encrypt.it")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    Text("Log in to your account")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    TextField("Email address", text: $email)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                        .textContentType(.password)
                    
                    if let errorMessage = authViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .padding([.top, .horizontal])
                    }
                    
                    Button(action: {
                        authViewModel.login(email: email, password: password)
                    }) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            Text("Sign in")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                    .background(Color.blue)
                    .cornerRadius(8)
                    .fontWeight(.bold)
                    
                    Button(action: {
                        // Implement Face ID action here
                    }) {
                        HStack {
                            Image(systemName: "faceid")
                                .foregroundColor(.black)
                            Text("Face ID")
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                    }
                    
                    NavigationLink(destination: SignupView()) {
                        Text("Don't have an account? Sign up")
                            .foregroundColor(.blue)
                            .padding()
                    }
                }
                .padding()
            }
        }
    }
}
struct MainView: View {
    @StateObject var authViewModel = AuthViewModel1()
    
    var body: some View {
        NavigationView {
            if authViewModel.isSignedIn {
                TabView {
                    HomeView()
                        .tabItem { Label("Home", systemImage: "house.fill") }

                    EncryptView()
                        .tabItem { Label("Encrypt", systemImage: "lock.fill") }

                    DecryptView()
                        .tabItem { Label("Decrypt", systemImage: "key.fill") }

                    SettingsView()
                        .tabItem { Label("Settings", systemImage: "gear") }
                }
            } else {
                LoginView()
                    .environmentObject(authViewModel)  // Pass the view model to LoginView
            }
        }
    }
}

struct HomeView: View {
    @State private var uploadedImages: [UploadedImage] = [
        UploadedImage(name: "Vacation", image: Image("vacation")),
        UploadedImage(name: "Family", image: Image("family")),
        UploadedImage(name: "Nature", image: Image("nature"))
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("wolf") // Background image
                    .resizable()
                    .ignoresSafeArea()
                
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
                                    .frame(width: 50, height: 50)
                                    .clipped()
                                    .cornerRadius(8)
                                
                                Text(uploadedImage.name)
                                    .font(.headline)
                                    .padding(.leading, 10)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                            .shadow(radius: 3)
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

// Decrypt view with placeholder content
struct DecryptView: View {
    var body: some View {
        ZStack {
            Image("wolf") // Background image
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Text("Decrypt Screen")
                // Additional UI components for decrypting an image
            }
            .padding()
        }
    }
}

struct EncryptView: View {
    var body: some View {
        ZStack {
            Image("wolf") // Background image
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Text("Encrypt Screen")
                // Additional UI components for encrypting an image
            }
            .padding()
        }
    }
}

struct AboutView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Image Steganography App")
                .font(.title)
                .fontWeight(.bold)
            Text("Version: 1.0")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("This app allows you to securely hide and reveal images within other images using encryption techniques.")
                .padding(.top)
            Spacer()
        }
        .padding()
        .navigationTitle("About")
    }
}

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    
    var body: some View {
        NavigationView {
            Form {
                
                Section(header: Text("About")) {
                    NavigationLink(destination: AboutView()) {
                        Text("About This App")
                    }
                }
                Section(header: Text("Other")) {
                    
                    Button {
                            Task{
                            await authViewModel.signOut()
                                                }
                                    } label: {
                                        Image(systemName:  "rectangle.portrait.and.arrow.right")
                                            }
                    
                    
                    
                }
                .navigationTitle("Settings")
            }
            
        }
    }
}

#Preview {
    LoginView().environmentObject(AuthViewModel())
}
