# Base Image

FROM python:3.11-slim

# Set working directory

WORKDIR /app

# copy app code

COPY app.py .

# run app

CMD [ "python", "app.py"]
