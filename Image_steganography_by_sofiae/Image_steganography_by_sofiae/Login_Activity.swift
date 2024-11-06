import SwiftUI
import CoreImage
import CoreGraphics
import Firebase
import FirebaseCore
import FirebaseAuth
import UIKit


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
    @State private var selectedEncryptedImage: UIImage?
    @State private var decryptedImage: UIImage?
    @State private var isProcessing: Bool = false
    @State private var errorMessage: String?

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
                
                if let decryptedImage = decryptedImage {
                    // Display Decrypted Image if available
                    DecryptionResultView(decryptedImage: decryptedImage)
                } else {
                    Text("No image decrypted yet.")
                        .foregroundColor(.gray)
                        .padding()

                    Button(action: {
                        // Simulate selecting an encrypted image
                        selectEncryptedImage()
                    }) {
                        Text("Select Encrypted Image")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    
                    if isProcessing {
                        ProgressView("Decrypting...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding()
                    }

                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                }
            }
            .padding()
        }
    }
    
    // Simulate image selection process (can be replaced with actual image picker logic)
    private func selectEncryptedImage() {
        // Here you would trigger an image picker or provide a way to select an encrypted image
        // For simplicity, let's simulate a selection of an encrypted image
        
        if let image = UIImage(named: "encryptedImage") { // Replace with actual encrypted image selection logic
            selectedEncryptedImage = image
            decryptImage()
        }
    }

    // Function to handle image decryption
    private func decryptImage() {
        guard let selectedEncryptedImage = selectedEncryptedImage else { return }
        
        isProcessing = true
        errorMessage = nil
        
        // Simulate decryption process (replace with actual decryption logic)
        DispatchQueue.global().async {
            // Simulating a decryption process (replace this with your actual algorithm)
            let decrypted = self.imageProcessorDecrypt(encryptedImage: selectedEncryptedImage)
            
            DispatchQueue.main.async {
                if let decryptedImage = decrypted {
                    self.decryptedImage = decryptedImage
                } else {
                    self.errorMessage = "Failed to decrypt the image. Try again."
                }
                self.isProcessing = false
            }
        }
    }

    // Simulated decryption function (replace with your actual decryption logic)
    private func imageProcessorDecrypt(encryptedImage: UIImage) -> UIImage? {
        // This is just a placeholder. Replace it with actual decryption code.
        // For example, applying a decoding algorithm here.
        return encryptedImage // Just returning the same image for demo purposes.
    }
}

struct DecryptionResultView: View {
    let decryptedImage: UIImage

    var body: some View {
        ZStack {
            Image("wolf") // Background image
                .resizable()
                .ignoresSafeArea()

            VStack {
                Text("Decrypted Image")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Image(uiImage: decryptedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()

                Spacer()
            }
        }
    }
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
        VStack {
            Text("Image Steganography")
                .font(.largeTitle)
                .padding()

            Button(action: {
                showingImagePicker = true
            }) {
                Text("Select Image")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding()
            }

            TextField("Enter Secret Text", text: $secretText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                encodeImage()
            }) {
                if isEncoding {
                    ProgressView()
                } else {
                    Text("Encode and Save Image")
                }
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
            .disabled(isEncoding || selectedImage == nil || secretText.isEmpty)
            
            if let encodedImage = encodedImage {
                Text("Encoded Image:")
                    .padding(.top)
                Image(uiImage: encodedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding()
                
                Button(action: {
                    UIImageWriteToSavedPhotosAlbum(encodedImage, nil, nil, nil)
                }) {
                    Text("Save Encoded Image")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            
            if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $selectedImage)
        }
        .padding()
    }
    
    func encodeImage() {
        guard let selectedImage = selectedImage,
              let imageData = selectedImage.pngData() else { return }
        
        isEncoding = true
        errorMessage = nil

        // Create URL request for the Flask backend
        let url = URL(string: "http://10.10.6.30:5000/encode")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Set up the request with boundary-based multipart form data
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = NSMutableData()
        
        // Append image data
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.png\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        
        // Append text data
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"text\"\r\n\r\n".data(using: .utf8)!)
        body.append(secretText.data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        
        // End boundary
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
                
                guard let data = data, let encodedUIImage = UIImage(data: data) else {
                    errorMessage = "Failed to encode image."
                    return
                }
                
                // Set the encoded image to display
                self.encodedImage = encodedUIImage
            }
        }.resume()
    }
}


struct ImagePicker: UIViewControllerRepresentable {
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
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
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
