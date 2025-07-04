FROM python:3.10

WORKDIR /app
COPY . /app

RUN pip install --no-cache-dir --upgrade pip  && pip install --no-cache-dir torch==2.1.2+cpu -f https://download.pytorch.org/whl/cpu/torch_stable.html  && pip install --no-cache-dir -r requirements.txt

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
