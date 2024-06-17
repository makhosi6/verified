from flask import Flask, request, jsonify
import cv2
from passport_ocr import detect_text_in_passport

app = Flask(__name__)

@app.route("/detect_text", methods=["POST"])
def detect_text():
    """
    API endpoint to detect text in a passport image.

    Returns:
        JSON: JSON response containing detected text regions or error message.
    """

    try:
        print(request);
        if "image" not in request.files:
            return jsonify({"error": "No image file uploaded."}), 400
        image_file = request.files["image"]

        # Access the uploaded file content directly (adjust based on your needs)
        image_data = image_file.read()  # You can further process the data here

        # ... (call text detection function using image_data)

        text_regions = detect_text_in_passport(image_data)  # Replace with actual processing

        return jsonify({"text_regions": text_regions})

    except Exception as e:
        print(f"Error: {e}")
        return jsonify({"error": "An error occurred during text detection."}), 500

if __name__ == "__main__":
    app.run(debug=True)

