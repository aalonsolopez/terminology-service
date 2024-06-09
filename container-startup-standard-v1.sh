#!/bin/bash

NAMESPACE=default
SERVICE_NAME="lookup-standard"

# 1. Check of the knative service is already running. If it is, delete it and wait for it to be deleted.

kubectl get ksvc $SERVICE_NAME -n $NAMESPACE

if [ $? -eq 0 ]; then
    kubectl delete ksvc $SERVICE_NAME -n $NAMESPACE --wait=true
    while [ $? -eq 0 ]; do
        sleep 1
        kubectl get ksvc $SERVICE_NAME -n $NAMESPACE
    done
fi

sleep 5

    echo "Deploying Knative Service"
    kubectl apply -f src/functions/lookup/standard/kubernetes/001-knative-service.yaml --wait=true
    sleep 10
    # 3. Check if the Knative Service is running. If it is, get the URL. Don't break the loop.
    echo "Checking if Knative Service is running"
    kubectl get ksvc $SERVICE_NAME -n $NAMESPACE


    if [ $? -eq 0 ]; then
        echo "Knative Service is running"
        echo "Getting the URL"
        URL=$(kubectl get ksvc $SERVICE_NAME -n $NAMESPACE -o jsonpath='{.status.url}')
    fi

    sleep 30

# 2. For a loop of N times, deploy the Knative Service.

echo "iteration_number,total_time_taken" > times-standard.txt

for i in {1..200}; do
    echo "----------------------------------------------------------------"
    
    echo "Iteration $i"
    # 4. When this is done, do a curl to the URL. Get only the total time taken for the curl, and save it to a file.

    echo "Curling the URL"

    { /usr/bin/time -f "%e" curl --header "Cache-Control: no-cache, no-store" $URL -o /dev/null -s ; } 2> curl-output-standard.txt

    CURL_TIME=$(head -n 1 curl-output-standard.txt)

    echo "Curl time: $CURL_TIME"

    echo "$i,$CURL_TIME" >> times-standard.txt

    echo "----------------------------------------------------------------"

    sleep 120
done
