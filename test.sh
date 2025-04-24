
curl \
    --header "Content-Type: application/json" \
    --request POST \
    --data '{"username1": "xavier"}' \
    http://localhost:50061/0

curl \
    --header "Content-Type: application/json" \
    --request POST \
    --data '{"username2": "xavier"}' \
    http://localhost:50061

curl \
    --header "Content-Type: application/json" \
    --request POST \
    --data '{"fuck": "you"}' \
    http://localhost:50061

curl http://localhost:50061/0/username5
curl http://localhost:50061/0/username1
curl http://localhost:50061/0/username2
curl http://localhost:50061/username1
curl http://localhost:50061/username2
