FROM python:3.9-slim

WORKDIR /app

# Install minimal system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    python3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY requirements.render.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.render.txt

# Copy application code
COPY finrobot/ ./finrobot/
COPY stackapp_api_render.py .
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
CMD ["gunicorn", "stackapp_api_render:app", "--workers", "2", "--bind", "0.0.0.0:8000"]
