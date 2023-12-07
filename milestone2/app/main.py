from fastapi import FastAPI
#psycopg2 is used to create connections to a database.
import psycopg2
# This library is useful for displaying various system information (container Id)
import os
# This is a function that will establish a connection to the postgres database
def get_user_data():
    conn = psycopg2.connect(
        host="postgres",
        database="milestone2",
        user="rob_verbeek",
        password="milestone2")
    # create a cursor object in order to navigate through the database records
    cur = conn.cursor()
    # execute an sql query that will retrieve all entries from the user_data table. In this case there is only 1 record in the user_data table
    cur.execute("SELECT * FROM user_data;")
    # return the data that is retrieved from the query. fetchone() will retrieve the first row from the previous query
    # [0] will make sure the value from the first row is retrieved.
    return cur.fetchone()[0]

# Create the FastAPI application
app = FastAPI()

# define endpoint /container which will retrieve the containerId of the API that is handling the request.
@app.get("/container")
# This function retrieves operating system information, more specifically .nodename returns the name of the container that is running this API.
async def get_container_id():
    container_id = os.uname().nodename  # Get the container ID using os module    
    return {"name": container_id}

#define endpoint /user which will retrieve the username from the postgres database.
@app.get("/user")
# This function will call upon the function above that establishes a connection to the database and queries information out of it, and return this data when a request is made.
async def get_user():
    user = get_user_data()
    return {"name": user}