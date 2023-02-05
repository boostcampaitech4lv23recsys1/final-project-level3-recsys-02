FROM amd64/python:3.9-slim

WORKDIR /usr/app

# RUN pip install -U pip \
#     && pip install "fastapi[all]"
COPY requirements.txt requirements.txt

RUN pip install -U pip && pip install -r requirements.txt

COPY backend-api.py backend-api.py

CMD ["python", "backend-api.py"]