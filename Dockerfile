FROM python:3.10-slim

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# System dependencies
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Python deps
RUN pip install --upgrade pip

# Safe versions
RUN pip install numpy==1.26.4
RUN pip install https://download.pytorch.org/whl/cpu/torch-2.1.2%2Bcpu-cp310-cp310-linux_x86_64.whl
RUN pip install transformers==4.40.1 uvicorn fastapi

# Add code
WORKDIR /app
COPY . .

# Preload check to fail early
COPY test_startup.py .
RUN python test_startup.py

# Set runtime port
ENV PORT=8080
EXPOSE 8080

CMD ["uvicorn", "main:app", "--host=0.0.0.0", "--port=8080", "--log-level=debug"]
