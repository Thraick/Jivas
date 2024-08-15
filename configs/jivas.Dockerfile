# Use an official Python runtime as a parent image
FROM python:3.11

# Set the working directory in the container
WORKDIR /app

# Install system dependencies (if any)
RUN apt-get update && apt-get install -y git vim procps jq lsof

# Install dependencies specified in requirements.txt (if any)
ADD src/requirements.txt .
RUN pip install --upgrade pip
RUN pip install --no-cache-dir --ignore-installed -r requirements.txt
RUN python3 -m spacy download en_core_web_sm

# Copy the current directory contents into the container at /app
ADD start.sh /app
ADD restart.sh /app
ADD run_test.sh /app
ADD init_jivas.sh /app
ADD .env /app
ADD src/ /app

# Make port 8000 available to the world outside this container
EXPOSE 8000

# Define environment variables, if any

# Run app.py when the container launches
# CMD ["sh", "-c", "/app/start.sh"]