from flask import Flask, request, jsonify, send_file
import cv2
import numpy as np
from PIL import Image
from flask_cors import CORS
from io import BytesIO

# Initialize the Flask app
app = Flask(__name__)  # Flask initialization
CORS(app)  # Enable CORS for cross-origin requests

class SteganographyException(Exception):
    pass

class LSBSteg():
    def __init__(self, im):
        self.image = im
        self.height, self.width, self.nbchannels = im.shape
        self.size = self.width * self.height
        self.maskONEValues = [1, 2, 4, 8, 16, 32, 64, 128]
        self.maskONE = self.maskONEValues.pop(0)
        self.maskZEROValues = [254, 253, 251, 247, 239, 223, 191, 127]
        self.maskZERO = self.maskZEROValues.pop(0)
        self.curwidth = 0
        self.curheight = 0
        self.curchan = 0

    def put_binary_value(self, bits):
        for c in bits:
            val = list(self.image[self.curheight, self.curwidth])
            if int(c) == 1:
                val[self.curchan] = int(val[self.curchan]) | self.maskONE
            else:
                val[self.curchan] = int(val[self.curchan]) & self.maskZERO
            self.image[self.curheight, self.curwidth] = tuple(val)
            self.next_slot()

    def next_slot(self):
        if self.curchan == self.nbchannels - 1:
            self.curchan = 0
            if self.curwidth == self.width - 1:
                self.curwidth = 0
                if self.curheight == self.height - 1:
                    self.curheight = 0
                    if self.maskONE == 128:
                        raise SteganographyException("No available slot remaining (image filled)")
                    else:
                        self.maskONE = self.maskONEValues.pop(0)
                        self.maskZERO = self.maskZEROValues.pop(0)
                else:
                    self.curheight += 1
            else:
                self.curwidth += 1
        else:
            self.curchan += 1

    def encode_text(self, text):
        binary_text = ''.join([format(ord(char), '08b') for char in text])
        binary_text_len = format(len(text), '016b')  # 16-bit length for the message
        binary_text = binary_text_len + binary_text

        print(f"Binary Text to Encode: {binary_text}")
        print(f"Text Length (in binary): {binary_text_len}")

        idx = 0
        for row in range(self.height):
            for col in range(self.width):
                for channel in range(self.nbchannels):
                    if idx < len(binary_text):
                        original_pixel_value = self.image[row, col, channel]
                        self.image[row, col, channel] = (self.image[row, col, channel] & 0xFE) | int(binary_text[idx])
                        print(f"Encoding pixel at ({row}, {col}), Channel {channel}: {original_pixel_value} -> {self.image[row, col, channel]}")
                        idx += 1
        
        # Save the image after encoding
        cv2.imwrite('encoded_image.png', self.image)  # Save the encoded image

        return self.image

    def decode_text(self):
        binary_data = ''
        idx = 0
        
        # First, extract the 16-bit length of the hidden message
        length_in_binary = ''
        for row in range(self.height):
            for col in range(self.width):
                for channel in range(self.nbchannels):
                    binary_data += str(self.image[row, col, channel] & 1)
                    idx += 1
                    if idx == 16:
                        length_in_binary = binary_data[:16]  # First 16 bits are the length
                        message_length = int(length_in_binary, 2)
                        print(f"Message length: {message_length} characters")
                        break
                if length_in_binary:  # Break outer loop once we have the length
                    break
        
        # Now extract the actual hidden message based on the length
        message_binary = binary_data[16:16 + message_length * 8]  # Extract the binary message
        decoded_text = ""
        
        # Ensure that we properly handle the binary data by decoding it in 8-bit chunks
        for i in range(0, len(message_binary), 8):
            byte = message_binary[i:i+8]
            if len(byte) == 8:  # Ensure that the byte is complete
                decoded_text += chr(int(byte, 2))
        
        print(f"Decoded Text: {decoded_text}")
        return decoded_text



@app.route('/encode', methods=['POST'])
def encode():
    image_file = request.files['image']
    text = request.form['text']
    image = np.array(Image.open(image_file))
    steg = LSBSteg(image)
    encoded_image = steg.encode_text(text)
    _, img_encoded = cv2.imencode('.png', encoded_image)
    return send_file(BytesIO(img_encoded.tobytes()), mimetype='image/png')

@app.route('/decode', methods=['POST'])
def decode():
    # Get the image from the request
    image_file = request.files['image']
    image = np.array(Image.open(image_file))
    steg = LSBSteg(image)
    
    decoded_text = steg.decode_text()
    
    return jsonify({"decoded_text": decoded_text})

# Start the Flask server
if __name__ == '__main__':
    app.run(debug=True)

