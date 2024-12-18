import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth

struct SignupView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    @State private var isVerificationSent: Bool = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                // Background image
                Image("wolf") // Replace with the name of your image asset
                    .resizable()
                    .ignoresSafeArea()

                ScrollView {
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
                            .fontWeight(.bold)
                            .foregroundColor(.white) +
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

                        // Confirm Password SecureField
                        SecureField("Confirm Password", text: $confirmPassword)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)

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
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            } else {
                                Text("Sign Up")
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            }
                        }
                        .background(Color.blue)
                        .cornerRadius(8)
                        .disabled(isLoading)

                        Spacer()

                        // Disclaimer text
                        Text("Already have an account? \n -------------- Login to your account --------------")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)

                        Spacer()

                        Button(action: {
                            dismiss()
                        }) {
                            Text("Login")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                        .background(Color.blue)
                        .cornerRadius(8)
                        .disabled(isLoading)
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Sign Up")
    }

    // Sign-up function with validation
    func signUp() {
        // Reset the error message
        errorMessage = nil

        // Validate email and password
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }
        
        guard isValidEmail(email) else {
            errorMessage = "Please enter a valid email address."
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }

        // Start loading
        isLoading = true

        // Sign up with Firebase
        Auth.auth().createUser(withEmail: email, password: password) { [self] authResult, error in
            isLoading = false // Access self without weak
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                // Send verification email
                authResult?.user.sendEmailVerification { error in
                    if let error = error {
                        errorMessage = error.localizedDescription
                    } else {
                        isVerificationSent = true
                        dismiss() // Dismiss view on success
                    }
                }
            }
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
