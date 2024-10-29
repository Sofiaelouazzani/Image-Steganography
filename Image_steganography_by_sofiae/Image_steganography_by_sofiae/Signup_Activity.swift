import SwiftUI

struct SignupView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirm_password: String = ""
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
                Text("Create a new account")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                // Email TextField
                TextField("Email address", text: $email)
                    .padding()
                    .background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                    .cornerRadius(8)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                
                // Password SecureField
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                    .cornerRadius(8)
                    .textContentType(.password)
                
                // Confirm Password SecureField
                SecureField("Confirm Password", text: $confirm_password)
                    .padding()
                    .background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                    .cornerRadius(8)
                    .textContentType(.password)
                
                // Error message
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding([.top, .horizontal])
                }
                
                Spacer()
                
                // Sign Up button
                Button(action: {
                    signUp()
                }) {
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding().fontWeight(.bold)
                }
                .background(Color.blue)
                .cornerRadius(8)
                .disabled(isLoading)
                
                Spacer()
                
                // Disclaimer text
                Text("By clicking \"Sign up\" above, you agree to Encrypt.it's Terms & Conditions and Privacy Policy.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding()
        }
    }

    // Sign-up function with validation
    func signUp() {
        // Reset the error message
        errorMessage = nil

        // Validate email and password
        guard !email.isEmpty, !password.isEmpty, !confirm_password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }
        
        guard isValidEmail(email) else {
            errorMessage = "Please enter a valid email address."
            return
        }
        
        guard password == confirm_password else {
            errorMessage = "Passwords do not match."
            return
        }

        // Start loading
        isLoading = true

        // Simulate a network request with a 3-second delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // Stop loading
            isLoading = false

            // Perform your sign-up logic here
            // ...
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        // Basic email validation regex
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

#Preview {
    SignupView()
}
