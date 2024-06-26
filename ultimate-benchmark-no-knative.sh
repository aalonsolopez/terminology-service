#!/bin/bash
TIME_FILE="curl_time.txt"
# echo "iteration_number,pod_name,total_time_taken" > startup-times-standard_def.csv
# echo "iteration_number,pod_name,response_time" > response-time-standard_def.csv


# for i in {1..200}; do
#     echo "----------------------------------------------------------------"
#     echo "Iteration $i"

#     echo "--- Standard -------------------------------------------------------"
    
#     kubectl apply -f src/functions/lookup/standard/kubernetes/000-k8s-deployment.yaml --wait=true --force

#     sleep 35

#     POD_NAME=$(kubectl get pods -l app=lookup-standard -o jsonpath='{.items[0].metadata.name}')

#     echo "Storing the standard pod data"

#     echo "$i,$(journalctl -u k3s.service -o cat | grep -E '*podStartE2EDuration*' | awk '{print $9,$11}' | tail -1 | awk -F'"' '{print $2","$4}')" >> startup-times-standard_def.csv

#     # Port-forward the service to localhost
#     echo "Port-forwarding service to localhost:8080..."
#     kubectl port-forward svc/lookup-standard 8080:8080 &
#     PORT_FORWARD_PID=$!

#     # Wait a few seconds to ensure port-forwarding is established
#     sleep 5

#     # Measure response time
#     URL="http://localhost:8080"
#     echo "Measuring response time for $URL"
#     # { time curl -o /dev/null -s -w "%{http_code}\n" $URL; } 2> $TIME_FILE

#     # # Extract the real time from the time command output
#     # REAL_TIME=$(grep real $TIME_FILE | awk '{print $2}')
    
#     RESPONSE_TIME=$(curl -o /dev/null -s -w "%{time_total}\n" $URL)

#     # Kill port-forward process
#     kill $PORT_FORWARD_PID

#     echo  "$i,$POD_NAME,$RESPONSE_TIME" >> response-time-standard_def.csv 
#     echo "Deleting standard pod"

#     kubectl delete -f src/functions/lookup/standard/kubernetes/000-k8s-deployment.yaml --wait=true --force

# done

echo "iteration_number,pod_name,total_time_taken" > startup-times-wasm_def.csv
echo "iteration_number,pod_name,response_time" > response-time-wasm_def.csv

for i in {1..200}; do
    echo "----------------------------------------------------------------"
    echo "Iteration $i"

    echo "--- WASM -------------------------------------------------------"
    
    kubectl apply -f src/functions/lookup/wasm/kubernetes/000-k8s-deployment.yaml --wait=true --force

    sleep 35

    POD_NAME=$(kubectl get pods -l app=lookup-wasm -o jsonpath='{.items[0].metadata.name}')

    echo "Storing the Wasm pod data"

    echo "$i,$(journalctl -u k3s.service -o cat | grep -E '*podStartE2EDuration*' | awk '{print $9,$11}' | tail -1 | awk -F'"' '{print $2","$4}')" >> startup-times-wasm_def.csv

    # Port-forward the service to localhost
    echo "Port-forwarding service to localhost:8080..."
    kubectl port-forward svc/lookup-wasm 8080:8080 &
    PORT_FORWARD_PID=$!

    # Wait a few seconds to ensure port-forwarding is established
    sleep 5

    # Measure response time
    URL="http://localhost:8080"
    echo "Measuring response time for $URL"
    # { time curl -o /dev/null -s -w "%{http_code}\n" $URL; } 2> $TIME_FILE

    # # Extract the real time from the time command output
    # REAL_TIME=$(grep real $TIME_FILE | awk '{print $2}')
    
    RESPONSE_TIME=$(curl -o /dev/null -s -w "%{time_total}\n" $URL)
    # Kill port-forward process
    kill $PORT_FORWARD_PID


    echo  "$i,$POD_NAME,$RESPONSE_TIME" >> response-time-wasm_def.csv 
    echo "Deleting Wasm pod"

    kubectl delete -f src/functions/lookup/wasm/kubernetes/000-k8s-deployment.yaml --wait=true --force

done