FROM python:3.10

WORKDIR /app
COPY . /app

# Clean install PyTorch + compatible NumPy (1.x)
RUN pip install --no-cache-dir --upgrade pip &&     pip install --no-cache-dir numpy==1.26.4 &&     pip install --no-cache-dir https://download.pytorch.org/whl/cpu/torch-2.1.2%2Bcpu-cp310-cp310-linux_x86_64.whl &&     pip install --no-cache-dir -r requirements.txt

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
