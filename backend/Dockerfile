FROM python:3.12.3-alpine3.20
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .
EXPOSE 5000
CMD ["python", "survey-analyzer.py"]