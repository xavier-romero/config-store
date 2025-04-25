# Description
This aims to be a simple storage config solution, you can run it standlone anywhere but it's been built with Kurtosis in mind.

For usage within Kurtosis, please refer to that [Kurtosis README](kurtosis/README.md), although description below could be useful to understand the principles.


# Run
## Run app
To run app listening on specific port:
```
PORT=9000 python3 app.py
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

Examples using curl (assuming the service is running on port 8000)
## Sending to default
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
```

## Sending to custom context
```
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
```

## Retrieve from default
```
# Retrieve value for specific key from default namespace
curl http://localhost:8000/0/username5
curl http://localhost:8000/0/username1
curl http://localhost:8000/0/username2
curl http://localhost:8000/username1
curl http://localhost:8000/username2

```

## Retrieve from specific context
```
# Retrieve value for specific key from custom namespace
curl http://localhost:8000/custom_namespace/username1
curl http://localhost:8000/custom_namespace/username2

```

## Retrieve all data
```
# Retrieve all available data (dump) from default namespace
curl http://localhost:8000
curl http://localhost:8000/dump/0

# Retrieve all available data (dump) from custom namespace
curl http://localhost:8000/dump/custom_namespace

```

## Sending complex data
```
# Store complex data
TEST_DICT='{
    "key1": {
        "pectra_enabled": false,
        "consensus_contract_type": "pessimistic",
        "options": [
            "bridge_spammer"
        ]
    },
    "deployment_stages": {
        "deploy_optimism_rollup": true
    },
    "package": {
        "source": "whatever",
        "predeployed_contracts": true,
        "op_contract_deployer_params": {
            "image": "this:one",
            "l1_artifacts_locator": "https://google.com",
            "l2_artifacts_locator": "https://google.com"
        }
    }
}'

curl \
    --header "Content-Type: application/json" \
    --request POST \
    --data "$TEST_DICT" \
    http://localhost:8000

```

## Retrieve complex data
```
# Retrieve complex data as a whole or specific items
curl http://localhost:8000/key1
curl http://localhost:8000/key1.options
curl http://localhost:8000/package
curl http://localhost:8000/package.op_contract_deployer_params.image

```
