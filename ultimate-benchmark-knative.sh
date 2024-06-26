#!/bin/bash
TIME_FILE="curl_time.txt"
echo "iteration_number,pod_name,total_time_taken" > startup-times-standard_knative.csv
echo "iteration_number,pod_name,response_time" > response-time-standard_knative.csv


for i in {1..200}; do
    echo "----------------------------------------------------------------"
    echo "Iteration $i"

    echo "--- Standard -------------------------------------------------------"
    
    kubectl apply -f src/functions/lookup/standard/kubernetes/001-knative-service.yaml --wait=true --force

    sleep 20

    # Measure response time
    URL="http://lookup-standard.default.172.28.244.252.sslip.io"
    echo "Measuring response time for $URL"
    
    RESPONSE_TIME=$(curl -o /dev/null -s -w "%{time_total}\n" $URL)

    sleep 10

    echo "Storing the standard pod data"

    echo "$i,$(journalctl -u k3s.service -o cat | grep -E '*podStartE2EDuration*' | awk '{print $9,$11}' | tail -1 | awk -F'"' '{print $2","$4}')" >> startup-times-standard_knative.csv

    POD_NAME=$(journalctl -u k3s.service -o cat | grep -E '*podStartE2EDuration*' | awk '{print $9,$11}' | tail -1 | awk -F'"' '{print $2}')

    echo  "$i,$POD_NAME,$RESPONSE_TIME" >> response-time-standard_knative.csv 
    echo "Deleting standard pod"

    kubectl delete -f src/functions/lookup/standard/kubernetes/001-knative-service.yaml --wait=true --force

    sleep 20

done

echo "iteration_number,pod_name,total_time_taken" > startup-times-wasm_knative.csv
echo "iteration_number,pod_name,response_time" > response-time-wasm_knative.csv

for i in {1..200}; do
    echo "----------------------------------------------------------------"
    echo "Iteration $i"

    echo "--- WASM -------------------------------------------------------"
    
    kubectl apply -f src/functions/lookup/wasm/kubernetes/001-knative-service.yaml --wait=true --force

    sleep 20

    # Measure response time
    URL="http://lookup-wasm.default.172.28.244.252.sslip.io"
    echo "Measuring response time for $URL"
    
    RESPONSE_TIME=$(curl -o /dev/null -s -w "%{time_total}\n" $URL)

    sleep 10

    echo "Storing the standard pod data"

    echo "$i,$(journalctl -u k3s.service -o cat | grep -E '*podStartE2EDuration*' | awk '{print $9,$11}' | tail -1 | awk -F'"' '{print $2","$4}')" >> startup-times-wasm_knative.csv

    POD_NAME=$(journalctl -u k3s.service -o cat | grep -E '*podStartE2EDuration*' | awk '{print $9,$11}' | tail -1 | awk -F'"' '{print $2}')

    echo  "$i,$POD_NAME,$RESPONSE_TIME" >> response-time-wasm_knative.csv 
    echo "Deleting standard pod"

    kubectl delete -f src/functions/lookup/wasm/kubernetes/001-knative-service.yaml --wait=true --force

    sleep 20

done