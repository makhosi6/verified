FROM python:3.7-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG en_US.UTF-8 

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

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
    g++ \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV TESSDATA_PREFIX=/usr/share/tesseract-ocr/tessdata/

# Verify Tesseract installation
RUN tesseract --version


WORKDIR /app

COPY . .

WORKDIR /app/apps/image_transcoder/

# Install Python packages
RUN pip install --no-cache-dir opencv-python-headless pytesseract flask

RUN ls -la

# RUN pip install -r /app/apps/image_transcoder/pkgs/mrz_reader/requirements.txt
# EXPOSE 5693
# Command to run the Flask server
CMD ["python", "app.py"]