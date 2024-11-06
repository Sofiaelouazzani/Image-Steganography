//
//  Untitled.swift
//  Image_steganography_by_sofiae
//
//  Created by Sofia Elouazzani on 2024-11-06.
//

import SwiftUI
import UIKit



// ImageProcessor class for handling image encryption and decryption
class ImageProcessor {
    
    // Function to encrypt an image with another image (basic example of steganography)
    func encryptImage(coverImage: UIImage, hiddenImage: UIImage) -> UIImage? {
        // Convert images to CGImage for pixel manipulation
        guard let coverCGImage = coverImage.cgImage, let hiddenCGImage = hiddenImage.cgImage else {
            return nil
        }
        
        // Ensure the hidden image is smaller or equal in size to the cover image
        let coverWidth = coverCGImage.width
        let coverHeight = coverCGImage.height
        let hiddenWidth = hiddenCGImage.width
        let hiddenHeight = hiddenCGImage.height
        
        if hiddenWidth > coverWidth || hiddenHeight > coverHeight {
            return nil // Hidden image is too large to embed
        }
        
        // Create contexts for both images
        guard let coverContext = CGContext(data: nil,
                                           width: coverWidth,
                                           height: coverHeight,
                                           bitsPerComponent: 8,
                                           bytesPerRow: coverWidth * 4,
                                           space: coverCGImage.colorSpace!,
                                           bitmapInfo: coverCGImage.bitmapInfo.rawValue),
              let hiddenContext = CGContext(data: nil,
                                            width: hiddenWidth,
                                            height: hiddenHeight,
                                            bitsPerComponent: 8,
                                            bytesPerRow: hiddenWidth * 4,
                                            space: hiddenCGImage.colorSpace!,
                                            bitmapInfo: hiddenCGImage.bitmapInfo.rawValue) else {
            return nil
        }
        
        // Draw both images into their contexts
        coverContext.draw(coverCGImage, in: CGRect(x: 0, y: 0, width: coverWidth, height: coverHeight))
        hiddenContext.draw(hiddenCGImage, in: CGRect(x: 0, y: 0, width: hiddenWidth, height: hiddenHeight))
        
        // Get pixel data for both images
        guard let coverData = coverContext.data,
              let hiddenData = hiddenContext.data else {
            return nil
        }
        
        // Perform pixel-wise manipulation (LSB steganography) to embed hidden image into the cover image
        let coverPixels = coverData.bindMemory(to: UInt32.self, capacity: coverWidth * coverHeight)
        let hiddenPixels = hiddenData.bindMemory(to: UInt32.self, capacity: hiddenWidth * hiddenHeight)
        
        for y in 0..<hiddenHeight {
            for x in 0..<hiddenWidth {
                let coverPixelIndex = (y * coverWidth + x)
                let hiddenPixelIndex = (y * hiddenWidth + x)
                
                var coverPixel = coverPixels[coverPixelIndex]
                let hiddenPixel = hiddenPixels[hiddenPixelIndex]
                
                // Embed hidden image pixel data into the LSB (Least Significant Bit)
                coverPixel = (coverPixel & 0xFFFFFF00) | (hiddenPixel & 0xFF) // Modify the LSB with hidden pixel
                
                // Store the new pixel in the cover image data
                coverPixels[coverPixelIndex] = coverPixel
            }
        }
        
        // Create a new image from the modified pixels
        guard let encryptedCGImage = coverContext.makeImage() else {
            return nil
        }
        
        return UIImage(cgImage: encryptedCGImage)
    }

    
    // Function to decrypt an image (extract hidden image from encrypted image)
    func decryptImage(encryptedImage: UIImage) -> UIImage? {
        guard let cgImage = encryptedImage.cgImage else {
            return nil
        }
        
        let width = cgImage.width
        let height = cgImage.height
        let colorSpace = cgImage.colorSpace
        let bitmapInfo: CGBitmapInfo = .byteOrder32Big // Correct usage of CGBitmapInfo
        
        // Create a CGContext to draw the image into pixel data
        let context = CGContext(data: nil,
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: width * 4, // 4 bytes per pixel (RGBA)
                                space: colorSpace!,
                                bitmapInfo: bitmapInfo.rawValue) // Use rawValue for CGBitmapInfo
        
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let pixelData = context?.data else {
            return nil
        }
        
        // Iterate through the pixel data
        for y in 0..<height {
            for x in 0..<width {
                let pixelIndex = (y * width + x) * 4
                var red = pixelData.load(fromByteOffset: pixelIndex, as: UInt8.self)
                var green = pixelData.load(fromByteOffset: pixelIndex + 1, as: UInt8.self)
                var blue = pixelData.load(fromByteOffset: pixelIndex + 2, as: UInt8.self)
                var alpha = pixelData.load(fromByteOffset: pixelIndex + 3, as: UInt8.self)
                
                // Assuming the hidden data is in the least significant bit (LSB)
                red &= 0b11111110
                green &= 0b11111110
                blue &= 0b11111110
                
                // Place back the modified pixel data into the image
                pixelData.storeBytes(of: red, toByteOffset: pixelIndex, as: UInt8.self)
                pixelData.storeBytes(of: green, toByteOffset: pixelIndex + 1, as: UInt8.self)
                pixelData.storeBytes(of: blue, toByteOffset: pixelIndex + 2, as: UInt8.self)
                pixelData.storeBytes(of: alpha, toByteOffset: pixelIndex + 3, as: UInt8.self)
            }
        }
        
        // Return the modified image with the decrypted information
        let decryptedCGImage = context?.makeImage()
        return decryptedCGImage != nil ? UIImage(cgImage: decryptedCGImage!) : nil
    }

    
    // Function to convert UIImage to Data (to send over the network or save)
    func convertImageToData(image: UIImage) -> Data? {
        return image.pngData()
    }
    
    // Function to convert Data to UIImage (to display in the UI)
    func convertDataToImage(data: Data) -> UIImage? {
        return UIImage(data: data)
    }
    
    // Example function to apply an encryption key or password to image data (advanced feature)
    func applyPasswordToImageData(imageData: Data, password: String) -> Data {
        // Simple encryption or transformation based on a password
        let passwordData = password.data(using: .utf8)!
        
        // Example: XOR image data with password data (this is a very simple encryption method)
        var encryptedData = Data()
        for (index, byte) in imageData.enumerated() {
            let passwordByte = passwordData[index % passwordData.count]
            encryptedData.append(byte ^ passwordByte)
        }
        
        return encryptedData
    }
}
