Secure Image Encryption and Steganography iOS App

Overview

This iOS application provides a powerful solution for image encryption and steganography. It allows users to securely encode and decode messages within images, ensuring the confidentiality of sensitive data. The app uses advanced image encryption techniques, coupled with steganography, to hide messages within the least significant bits of the image’s pixel data. 

Features

- Image Encryption: Securely encrypts image files to protect data.
- Steganography: Hides messages within the image itself, making it undetectable to the naked eye.
- User Authentication: Provides secure user login and signup functionality using Firebase authentication.
- Easy-to-use Interface: Intuitive UI built with SwiftUI for seamless user experience.
- Real-time Image Preview: View the original image and its encrypted form in real-time.
- Cross-platform Functionality: Fully functional on iOS devices, allowing users to encrypt and decrypt images on the go.
- Firebase Integration: Leverages Firebase for secure backend data storage and real-time updates.

Key Functionalities

1. Image Encryption & Decryption:
   - Users can encrypt images, which are then saved with embedded secret messages.
   - Decrypt the images to reveal hidden messages with a secure decryption process.

2. Text Message Embedding:
   - Text data can be encoded and hidden within an image without altering its visual appearance.
   
3. User Authentication:
   - Firebase authentication ensures secure user login and management.

4. Backend Support:
   - Firebase Firestore and Storage services are integrated for data storage, making it scalable and reliable.

Installation

Requirements

- Xcode (Latest version recommended)
- iOS 14.0 or later
- Swift 5.0 or later

Steps

1. Clone the repository:

2. Open the project in Xcode.

3. Build and run the app on a physical device or simulator.

4. Sign in or create a new account to start encrypting and decrypting images.

How to Use

1. Open the App: Launch the app on your iOS device.
2. Login/Signup: Sign in with your credentials or create a new account using Firebase Authentication.
3. Encrypt Image:
- Select an image from your device.
- Enter the message you wish to encode.
- Click the “Encrypt” button to hide the message within the image.
4. Decrypt Image:
- Choose the encrypted image from your gallery.
- Press “Decrypt” to reveal the hidden message.


## Screenshots

<div style="display: flex;">
  <img src="https://github.com/Sofiaelouazzani/Image-Steganography/raw/main/Preview%20Content/1.png" width="300" style="margin-right: 10px;" />
  <img src="https://github.com/Sofiaelouazzani/Image-Steganography/raw/main/Preview%20Content/3.png" width="300" />
</div>

**Login Screen**

The login screen provides a secure and seamless user authentication experience. Upon launching the app, users can sign in to their accounts using their registered credentials or create a new account. The login screen leverages Firebase Authentication to ensure that only authorized users can access the app’s core functionalities.

<div style="display: flex;">
  <img src="https://github.com/Sofiaelouazzani/Image-Steganography/raw/main/Preview%20Content/4.png" width="300" style="margin-right: 10px;" />
  <img src="https://github.com/Sofiaelouazzani/Image-Steganography/raw/main/Preview%20Content/5.png" width="300" />
</div>

**Image Selection**

In this screen, users can upload their desired image from their device to either encrypt or decrypt it. The selection process is simple, with file support for common image formats.

**Encryption Process**

This screenshot shows the image after the encryption process has been successfully completed. The app utilizes advanced image processing techniques to securely hide text within an image.

<div style="display: flex;">
  <img src="https://github.com/Sofiaelouazzani/Image-Steganography/raw/main/Preview%20Content/6.png" width="300" style="margin-right: 10px;" />
  <img src="https://github.com/Sofiaelouazzani/Image-Steganography/raw/main/Preview%20Content/7.png" width="300" />
</div>

**Decryption Process**

After the image has been encrypted, this screen shows the result of decrypting the hidden message from the image. Users can reveal the secret text embedded within the image using the decryption feature.

<div style="display: flex;">
  <img src="https://github.com/Sofiaelouazzani/Image-Steganography/raw/main/Preview%20Content/8.png" width="300" style="margin-right: 10px;" />
  <img src="https://github.com/Sofiaelouazzani/Image-Steganography/raw/main/Preview%20Content/9.png" width="300" />
</div>

**Output and Results**

Once the decryption process is complete, the app displays the decoded text, allowing the user to view the original message that was hidden in the image.
<div style="display: flex;">
  <img src="https://github.com/Sofiaelouazzani/Image-Steganography/raw/main/Preview%20Content/10.png" width="300" style="margin-right: 10px;" />
</div>



Technologies Used

- Swift: Primary programming language for building the iOS app.
- SwiftUI: Framework for creating the user interface.
- Firebase: Backend services for authentication, data storage, and real-time functionality.
- Core Image: For image processing and manipulation.
- CocoaPods: Dependency management tool used for third-party libraries (if applicable).

Contributing

We welcome contributions to improve the app! If you'd like to contribute, feel free to fork the repository and submit a pull request.

License

![Alt Text](images/1.png)


This project is licensed under the MIT License - see the LICENSE file for details.
