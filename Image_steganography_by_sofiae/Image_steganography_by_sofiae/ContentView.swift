import SwiftUI

struct ContentView: View {
    @State private var passcode: String = "" // State variable to store user input
    
    var body: some View {
        VStack {
            
                Text("Welcome to Image Steganography")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding().multilineTextAlignment(.leading)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(#colorLiteral(red: 0.2094851136, green: 0.636476934, blue: 0.2965449691, alpha: 1)))
                            .frame(width: 350, height: 100)
                    )
            
            Text("Encrypt your custom passcode into the cover image of your choice, allowing you to hide information seamlessly within any photo.")
                .padding()
            
            TextField("Enter Secret Passcode", text: $passcode)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
            
            Button(action: {
                // Action for button press
                print("Passcode entered: \(passcode)")
            }) {
                Text("Encrypt Image")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
            
            Spacer() // To push the content to the top
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
