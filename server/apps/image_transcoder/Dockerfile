FROM dockurr/windows:latest

WORKDIR /app

COPY install-python.ps1 .

RUN powershell -File install-python.ps1

RUN python --version

COPY requirements.txt . 

COPY . /

WORKDIR /app/pkgs/mrz_reader

RUN pip install -r requirements.txt

# CMD ["python"]