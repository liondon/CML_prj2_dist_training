FROM tensorflow/tensorflow:latest

# Install tools
# Run `docker build --no-cache .` to update the tools

# Install library dependencies
# These layer will be re-built when requirements.txt is updated
WORKDIR /app
# COPY requirements.txt /app
# RUN pip install --no-cache-dir -r requirements.txt

# Copy the project/code
# This layer changes most frequently
COPY mnist.py  /app/mnist.py
COPY main.py  /app/main.py
# COPY single.py  /app/single.py

ENV  TF_CONFIG='{"cluster": {"worker": ["172.18.0.1:12345", "172.18.0.1:23456"]}, "task": {"type": "worker", "index": 0} }'

# Run the service
CMD [ "python", "main.py" ]
# CMD [ "python", "single.py" ]
