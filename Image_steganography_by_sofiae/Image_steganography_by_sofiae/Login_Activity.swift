import SwiftUI
import CoreImage
import CoreGraphics
import Firebase
import FirebaseCore
import FirebaseAuth
import UIKit
import Photos





func encodeTextToImage(imageData: Data, text: String, completion: @escaping (UIImage?) -> Void) {
    let url = URL(string: "http://your-api-url/encode")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let boundary = UUID().uuidString
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    var body = Data()
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.png\"\r\n".data(using: .utf8)!)
    body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
    body.append(imageData)
    body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"text\"\r\n\r\n".data(using: .utf8)!)
    body.append(text.data(using: .utf8)!)
    body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
    
    request.httpBody = body
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            print("Error: \(String(describing: error))")
            completion(nil)
            return
        }
        completion(UIImage(data: data))
    }.resume()
}


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



// Decrypt view with placeholder content



import SwiftUI
import UIKit

struct DecryptView: View {
    @State private var selectedEncryptedImage: UIImage?
    @State private var decryptedMessage: String? = nil
    @State private var isProcessing: Bool = false
    @State private var errorMessage: String?
    @State private var isImagePickerPresented = false

    var body: some View {
        ZStack {
            Image("wolf") // Background image
                .resizable()
                .ignoresSafeArea()

            VStack {
                Text("Decrypt an Image")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()

                // Display selected image
                if let selectedImage = selectedEncryptedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .padding()
                } else {
                    Text("No image selected yet.")
                        .foregroundColor(.gray)
                        .padding()
                }

                // Display the decrypted message if available
                if let decryptedMessage = decryptedMessage {
                    Text("Decoded Message: \(decryptedMessage)")
                        .foregroundColor(.green)
                        .padding()
                } else {
                    Text("No decoded message yet.")
                        .foregroundColor(.gray)
                        .padding()
                }

                // Select Image Button
                Button(action: {
                    isImagePickerPresented = true
                }) {
                    Text("Select Image")
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                        .frame(maxWidth: .infinity)
                        .padding()
                }

                // Decrypt Button
                Button(action: {
                    decryptImage()
                }) {
                    Text("Decrypt Image")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .frame(maxWidth: .infinity)
                        .padding()
                }

                // Processing indicator
                if isProcessing {
                    ProgressView("Decrypting...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding()
                }

                // Display error message if any
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .padding()
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $selectedEncryptedImage, isPresented: $isImagePickerPresented)
        }
    }

    private func decryptImage() {
        guard let selectedEncryptedImage = selectedEncryptedImage else { return }

        isProcessing = true
        errorMessage = nil
        decryptedMessage = nil

        // Convert the UIImage to PNG data to send it to the server
        guard let imageData = selectedEncryptedImage.pngData() else {
            self.errorMessage = "Unable to convert image to data."
            isProcessing = false
            return
        }

        // Set up the URL for your Flask backend
        let url = URL(string: "http://127.0.0.1:5000/decode")! // Replace with your Flask server URL
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Create multipart form data to send the image
        var body = Data()
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Append the boundary string
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        // Append Content-Disposition for the image
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"encrypted_image.png\"\r\n".data(using: .utf8)!)
        // Append Content-Type for the image
        body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        
        // Append the actual image data
        body.append(imageData) // imageData is already of type Data

        // Close the boundary string
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body

        // Perform the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isProcessing = false
                if let error = error {
                    self.errorMessage = "Error during decryption: \(error.localizedDescription)"
                    return
                }

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    self.errorMessage = "Decryption failed with status code: \(httpResponse.statusCode)"
                    return
                }

                // Assuming the server sends back the decrypted message as JSON
                if let data = data {
                    do {
                        let decodedResponse = try JSONDecoder().decode([String: String].self, from: data)
                        self.decryptedMessage = decodedResponse["decoded_text"]
                    } catch {
                        self.errorMessage = "Failed to decode response."
                    }
                } else {
                    self.errorMessage = "Failed to receive a valid decrypted message."
                }
            }
        }.resume()
    }
}



struct ImagePicker: View {
    @Binding var selectedImage: UIImage?
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            ImagePickerView(selectedImage: $selectedImage, isPresented: $isPresented)
        }
    }
}

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var isPresented: Bool
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePickerView
        
        init(parent: ImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.isPresented = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}







import SwiftUI
import UIKit
import CoreImage

// MARK: - UIImage Extension
// Convert UIImage to pixel data (RGBA format)

// MARK: - EncryptView


struct EncryptView: View {
    @State private var selectedImage: UIImage?
    @State private var secretText: String = ""
    @State private var encodedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var isEncoding = false
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            Image("wolf") // Background image
                .resizable()
                .ignoresSafeArea()
            ScrollView {  // Adding ScrollView to handle overflow
                VStack {
                    Text("Encrypt Image")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                    
                    // Select Image Button
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        Text("Select Image")
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(8)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    
                    // Display selected image
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .padding()
                            
                    }
                       
                    
                    // Secret text input field
                    TextField("Enter Secret Text", text: $secretText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: .infinity)
                        .padding()
                        .padding()
                    
                    // Encode button
                    Button(action: {
                        encodeImage()
                    }) {
                        if isEncoding {
                            ProgressView()
                        } else {
                            Text("Encrypt it")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disabled(isEncoding || selectedImage == nil || secretText.isEmpty)
                    
                    // Display the encoded image and save button
                    if let encodedImage = encodedImage {
                        Text("Encoded Image:")
                            .padding(.top)
                        
                        Image(uiImage: encodedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .padding()
                        
                        Button(action: {
                            
                            // Save the encoded image to the photo library
                            UIImageWriteToSavedPhotosAlbum(encodedImage, nil, nil, nil)
                            
                        }) {
                            Text("Save Image")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    
                    // Show any error message
                    if let errorMessage = errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker1(image: $selectedImage)
                }
                .padding(.bottom, 80) // Prevent overlap with tab bar
            }
        }
    }

    // Encode image function
    func encodeImage() {
        guard let selectedImage = selectedImage,
              let imageData = selectedImage.pngData() else { return }

        isEncoding = true
        errorMessage = nil

        let url = URL(string: "http://127.0.0.1:5000/encode")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let body = NSMutableData()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.png\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)

        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"text\"\r\n\r\n".data(using: .utf8)!)
        body.append(secretText.data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body as Data

        // Perform network request
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isEncoding = false
                if let error = error {
                    errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    errorMessage = "Failed with status: \(httpResponse.statusCode)"
                    return
                }

                guard let data = data else {
                    errorMessage = "Failed to get image data."
                    return
                }

                // Try to create a UIImage from the received data
                if let encodedUIImage = UIImage(data: data) {
                    // Set the encoded image to display
                    self.encodedImage = encodedUIImage
                } else {
                    errorMessage = "Failed to decode image."
                }
            }
        }.resume()
    }

}



struct ImagePicker1: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker1

        init(_ parent: ImagePicker1) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            parent.image = info[.originalImage] as? UIImage
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

func imageSavedToPhotosAlbum(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeMutableRawPointer) {
    if let error = error {
        print("Error saving image: \(error.localizedDescription)")
    } else {
        print("Image saved successfully!")
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
