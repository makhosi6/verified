from flask import Flask, request, jsonify
from mrz_reader import MrzReader, PASSPORT_MRZ_LINE_LENGTH
from PIL import Image
import base64
import io
import os
import uuid


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
    
    mrz_reader=MrzReader()
    mrz_reader.load()
    mrz_dl,face=mrz_reader.predict(temp_file_path)
    # For now, just return a placeholder response
    return jsonify({"message": "successful", "data": mrz_dl})

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "OK"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5693)
