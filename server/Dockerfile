# Use an official Python runtime as a parent image
FROM python:2

# Set the working directory to /app
WORKDIR /app

# Copy the requirements.txt contents into the container at /app
ADD requirements.txt /app

# Install any needed packages specified in requirements.txt
RUN pip install -r requirements.txt

ADD app.py /app

# Make port 80 available to the world outside this container
EXPOSE 8080

# Define environment variable
# ENV NAME World

# Run app.py when the container launches
CMD ["python", "app.py"]
