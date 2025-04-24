# Run
## Run app
To run app listening on specific port:
```
python3 app.py 9000
```

To run on default port (8000):
```
python3 app.py
```

## Run docker
Build docker image:
```
docker build -f Dockerfile -t whatever:tag .
```

Run docker image on specific port:
```
docker run -e PORT=9000 -p 9000:9000 whatever:tag
```

Run docker image on default port (8000):
```
docker run -p 8000:8000 whatever:tag
```

# Usage
- Send data by posting JSON content
- Retrieve data by querying using key as GET parameter

Example using curl
```
# Send data to default namespace
curl \
    --header "Content-Type: application/json" \
    --request POST \
    --data '{"username1": "john"}' \
    http://localhost:8000/0

# Send data to default namespace
curl \
    --header "Content-Type: application/json" \
    --request POST \
    --data '{"username2": "jack"}' \
    http://localhost:8000


# Send data to custom namespace
curl \
    --header "Content-Type: application/json" \
    --request POST \
    --data '{"username1": "peter"}' \
    http://localhost:8000/custom_namespace

# Send data to custom namespace
curl \
    --header "Content-Type: application/json" \
    --request POST \
    --data '{"username2": "james"}' \
    http://localhost:8000/custom_namespace


# Retrieve value for specific key from default namespace
curl http://localhost:8000/0/username5
curl http://localhost:8000/0/username1
curl http://localhost:8000/0/username2
curl http://localhost:8000/username1
curl http://localhost:8000/username2

# Retrieve value for specific key from custom namespace
curl http://localhost:8000/custom_namespace/username1
curl http://localhost:8000/custom_namespace/username2

# Retrieve all available data (dump) from default namespace
curl http://localhost:8000
curl http://localhost:8000/dump/0

# Retrieve all available data (dump) from custm namespace
curl http://localhost:8000/dump/custom_namespace
```
