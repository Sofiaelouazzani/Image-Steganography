
                
import SwiftUI

struct LoginView: View {
@State private var email: String = ""
@State private var password: String = ""
@State private var isLoading: Bool = false
@State private var errorMessage: String?

var body: some View {
    ZStack {
        // Background image
        Image("wolf") // Replace with the name of your image asset
            .resizable()
            .ignoresSafeArea()
        VStack(spacing: 20) {
            Spacer()
            
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
                .fontWeight(.bold).foregroundColor(.white) +
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
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding([.top, .horizontal])
            }
            
            // Sign In button
            Button(action: {
                signIn()
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
            .disabled(isLoading).fontWeight(.bold)
            
            // Face ID button
            Button(action: {
                // Action for Face ID
            }) {
                HStack {
                    Image(systemName: "faceid")
                        .foregroundColor(.black)
                    Text("Face ID")
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
            }
            Spacer()
            Spacer()
            Text("Don't have an account? \n ---------- Sign up with the button below. ----------")
                .font(.footnote)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            Button(action: {
                // Action for Sign Up
                print("Navigate to Sign Up")
            }) {
                Text("Sign up")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .background(Color.blue)
            .cornerRadius(8)
            .disabled(isLoading).fontWeight(.bold)
            
            
            Spacer()
            
            // Disclaimer text
            
            
            
            Spacer()
        }
        .padding()
    }
}
func signIn() {
    // Reset the error message
    errorMessage = nil
    
    // Validate email and password
    guard !email.isEmpty, !password.isEmpty else {
        errorMessage = "Please fill in all fields."
        return
    }
    
    guard isValidEmail(email) else {
        errorMessage = "Please enter a valid email address."
        return
    }
    
    // Start loading
    isLoading = true
    
    // Simulate a network request with a 3 second delay
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        // Stop loading
        isLoading = false
        
        // Perform your sign-in logic here
        // ...
    }
}
    

func isValidEmail(_ email: String) -> Bool {
    // Basic email validation regex
    let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,64}$"
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
    return emailPredicate.evaluate(with: email)
}
}

#Preview {
LoginView()
}
                                    
