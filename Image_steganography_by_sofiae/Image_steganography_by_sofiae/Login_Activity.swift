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
struct YourApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject var authViewModel = AuthViewModel()  // Create an instance of AuthViewModel

    var body: some Scene {
        WindowGroup {
            NavigationView {
                if authViewModel.isSignedIn {
                    HomeView()  // Destination view after successful login
                } else {
                    LoginView()
                        .environmentObject(authViewModel)  // Pass the view model to LoginView
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
}

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false
    @State private var isSignedIn: Bool = false

    var body: some View {
            NavigationView{
                ZStack {
                    // Background image
                    Image("wolf") // Replace with the name of your image asset
                        .resizable()
                        .ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                        // Lock icon
                        Image(systemName: "lock.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                            .padding(.bottom, 20)
                        
                        // Welcome text
                        Text("Welcome to ")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white) +
                        Text("Encrypt.it")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                        
                        // Subtitle text
                        Text("Log in to your account")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        // Email TextField
                        TextField("Email address", text: $email)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                        
                        // Password SecureField
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                            .textContentType(.password)
                        
                        // Error message
                        if let errorMessage = authViewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.footnote)
                                .padding([.top, .horizontal])
                        }
                        Spacer()
                        
                        // Sign In button
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
                        
                        // Face ID button placeholder
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
                        
                        // Sign-up Navigation Link
                        NavigationLink(destination: SignupView()) {
                            Text("Don't have an account? Sign up")
                                .foregroundColor(.blue)
                                .padding()
                        }
                    }
                    .padding()
                }
            }
                .background(
                    NavigationLink(destination: MainView(), isActive: $isSignedIn) {
                        EmptyView()})
        }
    }
}

#Preview {
    LoginView().environmentObject(AuthViewModel())
}
