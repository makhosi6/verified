FROM --platform=linux/amd64 mylamour/tesseract-ocr:opencv

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8 

RUN apt-get update && apt-get install portaudio19-dev python3-pip libmysqlclient-dev tesseract-ocr-por -y
ENV TESSDATA_PREFIX=/usr/share/tesseract-ocr/tessdata/

WORKDIR /app

COPY . .

RUN ls -la

WORKDIR /app/apps/image_transcoder/pkgs/mrz_reader/

RUN ls -la

# RUN pip3 install -r ./requirements.txt

# CMD python3 mrz_reader.py
CMD ["python3", "--version"]