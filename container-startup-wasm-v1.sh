#!/bin/bash

NAMESPACE_WASM=default
SERVICE_NAME_WASM="lookup-wasm"

# 1. Check of the knative service is already running. If it is, delete it and wait for it to be deleted.

kubectl get ksvc $SERVICE_NAME_WASM -n $NAMESPACE_WASM

if [ $? -eq 0 ]; then
    kubectl delete ksvc $SERVICE_NAME_WASM -n $NAMESPACE_WASM --wait=true
    while [ $? -eq 0 ]; do
        sleep 1
        kubectl get ksvc $SERVICE_NAME_WASM -n $NAMESPACE_WASM
    done
fi

sleep 5

    echo "Deploying Knative Service"
    kubectl apply -f src/functions/lookup/wasm/kubernetes/001-knative-service.yaml --wait=true
    sleep 10
    # 3. Check if the Knative Service is running. If it is, get the URL. Don't break the loop.
    echo "Checking if Knative Service is running"
    kubectl get ksvc $SERVICE_NAME_WASM -n $NAMESPACE_WASM


    if [ $? -eq 0 ]; then
        echo "Knative Service is running"
        echo "Getting the URL"
        URL_WASM=$(kubectl get ksvc $SERVICE_NAME_WASM -n $NAMESPACE_WASM -o jsonpath='{.status.url}')
    fi

    sleep 30

# 2. For a loop of N times, deploy the Knative Service.

echo "iteration_number,total_time_taken" > times-wasm.txt

for u in {1..200}; do
    echo "----------------------------------------------------------------"
    
    echo "Iteration $u"
    # 4. When this is done, do a curl to the URL. Get only the total time taken for the curl, and save it to a file.

    echo "Curling the URL"

    { /usr/bin/time -f "%e" curl --header "Cache-Control: no-cache, no-store" $URL_WASM -o /dev/null -s ; } 2> curl-output-wasm.txt

    CURL_TIME_WASM=$(head -n 1 curl-output-wasm.txt)

    echo "Curl time: $CURL_TIME_WASM"

    echo "$u,$CURL_TIME_WASM" >> times-wasm.txt

    echo "----------------------------------------------------------------"

    sleep 120
done
