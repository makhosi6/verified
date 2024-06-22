FROM python:3.7-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG en_US.UTF-8

# Install locales and configure language settings
RUN apt-get update && \
    apt-get install -y locales && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Tesseract OCR and OpenCV dependencies
RUN apt-get update && \
 apt-get install -y \
 tesseract-ocr \
 libtesseract-dev \
 libleptonica-dev \
 pkg-config \
 libpng-dev \
 libjpeg-dev \
 libtiff-dev \
 zlib1g-dev \
 libicu-dev \
 libpango1.0-dev \
 libcairo2-dev \
 g++ && \
 apt-get clean && \
 rm -rf /var/lib/apt/lists/*


# Verify Tesseract installation
RUN tesseract --version

# Set the working directory
WORKDIR /app/

# Copy the current directory contents into the container at /app
COPY . .

# Set the Tesseract data prefix environment variable to the default location
ENV TESSDATA_PREFIX=/app/Tesseract-OCR/tessdata


# Install Python packages
RUN pip install --no-cache-dir opencv-python-headless pytesseract flask

# List directory contents to verify files
RUN ls -la

# 
RUN pip install -r /app/requirements.txt

# Expose the Flask port (uncomment if needed)
EXPOSE 5693

# Command to run the Flask server
CMD ["python", "app.py"]
