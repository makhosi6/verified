FROM python:3.9

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt
RUN apt-get update && apt-get install -y python3-opencv
RUN pip install opencv-python

COPY src/ .

EXPOSE 5045

CMD ["flask", "run", "--host", "0.0.0.0", "--port", "5045"]
