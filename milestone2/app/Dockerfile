# Pull the python image base for the container
FROM python:3.10.13-bullseye
# Install required modules
RUN python3 -m pip install fastapi "uvicorn[standard]" psycopg2

WORKDIR /code
# Copy the current directory into the working directory
COPY . .
# launch uvicorn, the API and allow requests from all interfaces.
CMD ["uvicorn","main:app", "--host", "0.0.0.0", "--port", "8000"]