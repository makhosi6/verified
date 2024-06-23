

from flask import Flask, request, jsonify
from PIL import Image
import base64
import io
import os
import uuid
import pytesseract


PASSPORT_MRZ_LINE_LENGTH = 44

def extract_mrz_from_passport_image(passport_image_filename: str):

    # See the `config/` dir for more info
    raw_passport_text = pytesseract.image_to_string(passport_image_filename)

    # Only grab text lines that aren't empty
    passport_text_lines = [x for x in raw_passport_text.split("\n") if x]

    # remember, MRZ is always the bottom 2 lines of a passport
    return passport_text_lines[-2:]



app = Flask(__name__)

@app.route('/')
def home():
    return "Welcome to the Flask server!"

@app.route('/ocr', methods=['POST'])
def ocr():
    if 'file' not in request.files and 'data_url' not in request.form:
        return jsonify({"error": "No file or data URL provided"}), 400

    if 'file' in request.files:
        # Handle file upload (PNG, JPG)
        file = request.files['file']
        try:
            image = Image.open(file)
        except Exception as e:
            return jsonify({"error": str(e)}), 400
    elif 'data_url' in request.form:
        # Handle data URL
        data_url = request.form['data_url']
        try:
            header, encoded = data_url.split(",", 1)
            data = base64.b64decode(encoded)
            image = Image.open(io.BytesIO(data))
        except Exception as e:
            return jsonify({"error": str(e)}), 400
    
    # Generate a unique temporary file name
    temp_file_name = f"{uuid.uuid4().hex}.png"
    temp_file_path = os.path.join("/tmp", temp_file_name)
    
    # Save the image to the temporary file
    image.save(temp_file_path)
    
    mrz_dl=extract_mrz_from_passport_image(temp_file_path)
    # For now, just return a placeholder response
    return jsonify({"message": "successful", "data": mrz_dl})

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "OK"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5694)





