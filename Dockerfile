FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY requirements.mvp.cloud.txt .
RUN pip install --no-cache-dir -r requirements.mvp.cloud.txt

# Copy application code
COPY finrobot/ ./finrobot/
COPY stackapp_api_huggingface.py .
COPY stackapp_config.json .
COPY env.example.minimal .env.example

# Create non-root user for security
RUN useradd -m stackapp
USER stackapp

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    STACKAPP_HOST=0.0.0.0 \
    STACKAPP_PORT=8000 \
    NODE_ENV=production

# Expose the application port
EXPOSE 8000

# Run the application with Gunicorn for production
CMD ["gunicorn", "stackapp_api_huggingface:app", "--workers", "4", "--worker-class", "uvicorn.workers.UvicornWorker", "--bind", "0.0.0.0:8000"]
