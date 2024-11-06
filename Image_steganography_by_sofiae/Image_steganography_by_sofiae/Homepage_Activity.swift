import SwiftUI
import Combine
import FirebaseAuth
import Foundation


// Model to represent uploaded images
struct UploadedImage: Identifiable {
    let id = UUID()
    let name: String
    let image: Image
}
enum UserStateError: Error{
    case signInError, signOutError
}

class AuthViewModel1: ObservableObject {
    @Published var isSignedIn = true
    @Published var isBusy = false
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

        func signOut() async -> Result<Bool, UserStateError>  {
            isBusy = true
                do{
                    try await Task.sleep(nanoseconds: 1_000_000_000)
                    isSignedIn = false
                    isBusy = false
                    return .success(true)
                }catch{
                    isBusy = false
                    return .failure(.signOutError)
                }
            }
}


// Main View with TabView


// Home view with a scrollable list of uploaded images

// Encrypt view with placeholder content



// Enhanced Settings view with toggles and slider

        
        // About view to provide app details
        
        
        
        // Preview
        
        
        // Tab bar styling modifier
    
