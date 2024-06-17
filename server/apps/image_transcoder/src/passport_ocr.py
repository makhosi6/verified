import cv2

def detect_text_in_passport(image_path):
    """
    Detects text in a passport image using OpenCV.

    Args:
        image_path (str): Path to the passport image.

    Returns:
        list: List of detected text regions.
    """

    img = cv2.imread(image_path)
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    # Apply adaptive thresholding for better text extraction (adjust parameters if needed)
    thresh = cv2.adaptiveThreshold(gray, 255, cv2.ADAPTIVE_THRESH_MEAN_C, cv2.THRESH_BINARY, 11, 2)

    # Find contours of potential text regions
    contours, _ = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    text_regions = []
    for cnt in contours:
        x, y, w, h = cv2.boundingRect(cnt)
        aspect_ratio = float(w) / h
        if aspect_ratio > 0.2 and aspect_ratio < 1.0 and cv2.contourArea(cnt) > 100:  # Adjust area threshold based on image size
            text_regions.append((x, y, w, h))

    return text_regions
